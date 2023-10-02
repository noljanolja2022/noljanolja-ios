//
//  GoogleAuthViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/10/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - GoogleAuthViewModelDelegate

protocol GoogleAuthViewModelDelegate: AnyObject {
    func googleAuthViewModelDidComplete(_ user: User)
}

// MARK: - GoogleAuthViewModel

final class GoogleAuthViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Bool>?

    // MARK: Action

    let action = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let authUseCase: AuthServiceType
    private let userService: UserServiceType
    private weak var delegate: GoogleAuthViewModelDelegate?

    // MARK: Private

    private let getUserAction = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(authUseCase: AuthServiceType = AuthService.default,
         userService: UserServiceType = UserService.default,
         delegate: GoogleAuthViewModelDelegate? = nil) {
        self.authUseCase = authUseCase
        self.userService = userService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        action
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Fail<String, Error>(error: CommonError.captureSelfNotFound)
                        .eraseToAnyPublisher()
                }
                return self.authUseCase
                    .signInWithGoogle(additionalScopes: [GIDSignInScope.youtube])
            }
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    getUserAction.send()
                case .failure:
                    alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)

        getUserAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Fail<User, Error>(error: CommonError.captureSelfNotFound)
                        .eraseToAnyPublisher()
                }
                return self.userService.getCurrentUser()
            }
            .sink { [weak self] result in
                guard let self else { return }
                isProgressHUDShowing = false
                switch result {
                case let .success(model):
                    delegate?.googleAuthViewModelDidComplete(model)
                case .failure:
                    alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)
    }
}
