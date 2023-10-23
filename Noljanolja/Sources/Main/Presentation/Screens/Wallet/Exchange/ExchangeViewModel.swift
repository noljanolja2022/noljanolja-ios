import _SwiftUINavigationState
import Combine
import Foundation

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

    // MARK: Dependencies

    private let memberInfoUseCase: MemberInfoUseCases
    private let coinExchangeUseCase: CoinExchangeUseCase
    private let coinExchangeRepository: CoinExchangeRepository
    private weak var listener: ExchangeListener?

    // MARK: Private

    private let memberInfoSubject = CurrentValueSubject<LoyaltyMemberInfo?, Never>(nil)
    private let coinModelSubject = CurrentValueSubject<CoinModel?, Never>(nil)
    private let coinExchangeRateSubject = CurrentValueSubject<CoinExchangeRate?, Never>(nil)

    private var cancellables = Set<AnyCancellable>()

    init(memberInfoUseCase: MemberInfoUseCases = MemberInfoUseCasesImpl.default,
         coinExchangeUseCase: CoinExchangeUseCase = CoinExchangeUseCaseImpl.shared,
         coinExchangeRepository: CoinExchangeRepository = CoinExchangeRepositoryImpl.shared,
         listener: ExchangeListener? = nil) {
        self.memberInfoUseCase = memberInfoUseCase
        self.coinExchangeUseCase = coinExchangeUseCase
        self.coinExchangeRepository = coinExchangeRepository
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

        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<(LoyaltyMemberInfo, CoinModel, CoinExchangeRate), Error> in
                guard let self else {
                    return Empty<(LoyaltyMemberInfo, CoinModel, CoinExchangeRate), Error>().eraseToAnyPublisher()
                }
                return Publishers.Zip3(
                    self.memberInfoUseCase.getLoyaltyMemberInfo(),
                    self.coinExchangeUseCase.getCoin(),
                    self.coinExchangeRepository.getCoinExchangeRate()
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

    private func configureActions() {}
}
