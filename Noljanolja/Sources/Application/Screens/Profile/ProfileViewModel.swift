//
//  ProfileViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - ProfileViewModelDelegate

protocol ProfileViewModelDelegate: AnyObject {
    func didSignOut()
}

// MARK: - ProfileViewModel

final class ProfileViewModel: ViewModel {
    // MARK: State

    @Published var user: User?

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Navigations

    @Published var navigationType: ProfileNavigationType?

    // MARK: Action

    let signOutAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let userService: UserServiceType
    private let authService: AuthServiceType
    private weak var delegate: ProfileViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(userService: UserServiceType = UserService.default,
         authService: AuthServiceType = AuthService.default,
         delegate: ProfileViewModelDelegate? = nil) {
        self.userService = userService
        self.authService = authService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        isAppearSubject
            .first(where: { $0 })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<User, Error>().eraseToAnyPublisher()
                }
                return self.userService.getCurrentUserIfNeeded()
            }
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(user):
                    self.user = user
                case .failure:
                    self.alertState = AlertState(
                        title: TextState("Error"),
                        message: TextState(L10n.Common.Error.message),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)

        signOutAction
            .handleEvents(receiveOutput: { [weak self] in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }
                return self.authService.signOut()
            }
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    self.delegate?.didSignOut()
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: SettingViewModelDelegate

extension ProfileViewModel: SettingViewModelDelegate {
    func didSignOut() {
        delegate?.didSignOut()
    }
}
