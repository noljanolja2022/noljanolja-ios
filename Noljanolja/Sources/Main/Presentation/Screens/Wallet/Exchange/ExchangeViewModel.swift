import _SwiftUINavigationState
import Combine
import Foundation
import GoogleMobileAds

// MARK: - ExchangeListener

protocol ExchangeListener: AnyObject {}

// MARK: - ExchangeViewModel

final class ExchangeViewModel: ViewModel {
    // MARK: State
    
    @Published var viewState = ViewState.loading
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var model: ExchangeViewDataModel?

    // MARK: Navigations

    @Published var navigationType: ExchangeNavigationType?
    @Published var fullScreenCoverType: ExchangeFullScreenCoverType?
    
    // MARK: Actions
    
    let exchangeAction = PassthroughSubject<Void, Never>()
    
    private let reloadAction = PassthroughSubject<Void, Never>()
    private let convertAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private var userDefaults: UserDefaultsType
    private let memberInfoUseCase: MemberInfoUseCases
    private let coinExchangeUseCases: CoinExchangeUseCases
    private let coinExchangeNetworkRepository: CoinExchangeNetworkRepository
    private let adMobNetworkRepository: AdMobNetworkRepository
    private weak var listener: ExchangeListener?

    // MARK: Private
    
    private var rewardedAd: GADRewardedAd?
    private let memberInfoSubject = CurrentValueSubject<LoyaltyMemberInfo?, Never>(nil)
    private let coinModelSubject = CurrentValueSubject<CoinModel?, Never>(nil)
    private let coinExchangeRateSubject = CurrentValueSubject<CoinExchangeRate?, Never>(nil)

    private var cancellables = Set<AnyCancellable>()

    init(userDefaults: UserDefaultsType = UserDefaults.standard,
         memberInfoUseCase: MemberInfoUseCases = MemberInfoUseCasesImpl.default,
         coinExchangeUseCases: CoinExchangeUseCases = CoinExchangeUseCasesImpl.shared,
         coinExchangeNetworkRepository: CoinExchangeNetworkRepository = CoinExchangeNetworkRepositoryImpl.shared,
         adMobNetworkRepository: AdMobNetworkRepository = AdMobNetworkRepositoryImpl.shared,
         listener: ExchangeListener? = nil) {
        self.userDefaults = userDefaults
        self.memberInfoUseCase = memberInfoUseCase
        self.coinExchangeUseCases = coinExchangeUseCases
        self.coinExchangeNetworkRepository = coinExchangeNetworkRepository
        self.adMobNetworkRepository = adMobNetworkRepository
        self.listener = listener
        super.init()

        configure()
    }

    private func configure() {
        configureActions()
        configureLoadData()
    }

    private func configureLoadData() {
        Publishers.CombineLatest3(
            memberInfoSubject.compactMap { $0 },
            coinModelSubject.compactMap { $0 },
            coinExchangeRateSubject.compactMap { $0 }
        )
        .map {
            ExchangeViewDataModel(memberInfo: $0, coinModel: $1, coinExchangeRate: $2)
        }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] in
            self?.model = $0
        }
        .store(in: &cancellables)
        
        Publishers.Merge(
            isAppearSubject.first(where: { $0 }).mapToVoid(),
            reloadAction
        )
        .receive(on: DispatchQueue.main)
        .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
        .flatMapLatestToResult { [weak self] _ -> AnyPublisher<(LoyaltyMemberInfo, CoinModel, CoinExchangeRate), Error> in
            guard let self else {
                return Fail<(LoyaltyMemberInfo, CoinModel, CoinExchangeRate), Error>(
                    error: CommonError.captureSelfNotFound
                )
                .eraseToAnyPublisher()
            }
            return Publishers.CombineLatest3(
                self.memberInfoUseCase.getLoyaltyMemberInfo(),
                self.coinExchangeUseCases.getCoin(),
                self.coinExchangeNetworkRepository.getCoinExchangeRate()
            )
            .eraseToAnyPublisher()
        }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success((memberInfo, coinModel, coinExchangeRate)):
                self.memberInfoSubject.send(memberInfo)
                self.coinModelSubject.send(coinModel)
                self.coinExchangeRateSubject.send(coinExchangeRate)
                self.viewState = .content
            case .failure:
                self.viewState = .error
            }
        }
        .store(in: &cancellables)
    }

    private func configureActions() {
        let (showAdAction, convertActionWithoutAd) = exchangeAction
            .withLatestFrom(coinExchangeRateSubject.compactMap { $0?.rewardRecurringAmount })
            .partition { [weak self] rewardRecurringAmount in
                self?.userDefaults.exchangeCount ?? 0 >= rewardRecurringAmount
            }
        
        showAdAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<GADRewardedAd, Error> in
                guard let self else {
                    return Fail<GADRewardedAd, Error>(
                        error: CommonError.captureSelfNotFound
                    )
                    .eraseToAnyPublisher()
                }
                return self.adMobNetworkRepository
                    .loadRewardedAd()
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(ad):
                    guard let viewController = UIApplication.shared.rootKeyWindow?.topViewController else {
                        self.alertState = AlertState(
                            title: TextState(L10n.commonErrorTitle),
                            message: TextState(L10n.commonErrorDescription),
                            dismissButton: .cancel(TextState("OK"))
                        )
                        return
                    }
                    self.rewardedAd = ad
                    ad.present(fromRootViewController: viewController) {
                        self.convertAction.send()
                        self.userDefaults.exchangeCount = 0
                    }
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)
        
        Publishers.Merge(convertActionWithoutAd.mapToVoid(), convertAction)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<CoinExchangeResult, Error> in
                guard let self, let exchangePoint = model?.exchangePoint else {
                    return Fail<CoinExchangeResult, Error>(
                        error: CommonError.captureSelfNotFound
                    )
                    .eraseToAnyPublisher()
                }
                return self.coinExchangeNetworkRepository
                    .convert(exchangePoint)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    self.reloadAction.send()
                    self.userDefaults.exchangeCount = self.userDefaults.exchangeCount + 1
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)
    }
}
