//
//  ReferralViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/08/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - ReferralViewModelDelegate

protocol ReferralViewModelDelegate: AnyObject {}

// MARK: - ReferralViewModel

final class ReferralViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.loading
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var currentUser: User?

    // MARK: Navigations

    @Published var fullScreenCoverType: ReferralFullScreenCoverType?
    @Published var navigationType: ReferralFullScreenNavigationType?

    // MARK: Action

    // MARK: Dependencies

    private let userUseCases: UserUseCases
    private weak var delegate: ReferralViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(userUseCases: UserUseCases = UserUseCasesImpl.default,
         delegate: ReferralViewModelDelegate? = nil) {
        self.userUseCases = userUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Fail<User, Error>(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }
                return self.userUseCases.getCurrentUserIfNeeded()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.currentUser = model
                    self.viewState = .content
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: ShareReferralContainerViewModelDelegate

extension ReferralViewModel: ShareReferralContainerViewModelDelegate {
    func pushToChat(conversationId: Int?) {
        guard let conversationId else { return }
        navigationType = .chat(conversationId)
    }
}
