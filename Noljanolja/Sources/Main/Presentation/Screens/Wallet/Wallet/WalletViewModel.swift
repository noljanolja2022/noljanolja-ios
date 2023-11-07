//
//  WalletViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - WalletViewModelDelegate

protocol WalletViewModelDelegate: AnyObject {
    func walletViewModelSignOut()
}

// MARK: - WalletViewModel

final class WalletViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.loading
    @Published var model: WalletModel?
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Navigations

    @Published var navigationType: WalletNavigationType?

    // MARK: Action

    // MARK: Dependencies

    private let userUseCases: UserUseCases
    private let memberInfoUseCase: MemberInfoUseCases
    private let coinExchangeUseCases: CoinExchangeUseCases
    private let checkinUseCases: CheckinUseCases
    private weak var delegate: WalletViewModelDelegate?

    // MARK: Private

    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)
    private let memberInfoSubject = CurrentValueSubject<LoyaltyMemberInfo?, Never>(nil)
    private let coinModelSubject = CurrentValueSubject<CoinModel?, Never>(nil)
    private let checkinProgressesSubject = CurrentValueSubject<[CheckinProgress]?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()

    init(userUseCases: UserUseCases = UserUseCasesImpl.default,
         memberInfoUseCase: MemberInfoUseCases = MemberInfoUseCasesImpl.default,
         checkinUseCases: CheckinUseCases = CheckinUseCasesImpl.shared,
         coinExchangeUseCases: CoinExchangeUseCases = CoinExchangeUseCasesImpl.shared,
         delegate: WalletViewModelDelegate? = nil) {
        self.userUseCases = userUseCases
        self.memberInfoUseCase = memberInfoUseCase
        self.coinExchangeUseCases = coinExchangeUseCases
        self.checkinUseCases = checkinUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureActions()
        configureLoadData()
    }

    private func configureLoadData() {
        Publishers.CombineLatest4(
            currentUserSubject.compactMap { $0 },
            memberInfoSubject.compactMap { $0 },
            coinModelSubject.compactMap { $0 },
            checkinProgressesSubject.compactMap { $0 }
        )
        .map {
            WalletModel(currentUser: $0, memberInfo: $1, coinModel: $2, checkinProgresses: $3)
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
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<(LoyaltyMemberInfo, CoinModel, [CheckinProgress]), Error> in
                guard let self else {
                    return Empty<(LoyaltyMemberInfo, CoinModel, [CheckinProgress]), Error>().eraseToAnyPublisher()
                }
                return Publishers.CombineLatest3(
                    self.memberInfoUseCase.getLoyaltyMemberInfo(),
                    self.coinExchangeUseCases.getCoin(),
                    self.checkinUseCases.getCheckinProgresses()
                )
                .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success((memberInfo, coinModel, checkinProgresses)):
                    self.memberInfoSubject.send(memberInfo)
                    self.coinModelSubject.send(coinModel)
                    self.checkinProgressesSubject.send(checkinProgresses)
                    self.viewState = .content
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)

        userUseCases
            .getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in self?.currentUserSubject.send($0) })
            .store(in: &cancellables)
    }

    private func configureActions() {}
}

// MARK: ProfileSettingViewModelDelegate

extension WalletViewModel: ProfileSettingViewModelDelegate {
    func profileSettingViewModelSignOut() {
        delegate?.walletViewModelSignOut()
    }
}
