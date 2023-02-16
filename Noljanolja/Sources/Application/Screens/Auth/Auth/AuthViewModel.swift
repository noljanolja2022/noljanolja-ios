//
//  AuthViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/02/2023.
//

import Combine

// MARK: - AuthViewModelDelegate

protocol AuthViewModelDelegate: AnyObject {}

// MARK: - AuthViewModelType

protocol AuthViewModelType: ObservableObject, SignInViewModelDelegate, SignUpNavigationViewModelDelegate {
    // MARK: State

    var isShowingResetPasswordView: Bool { get set }
    var termItemType: TermItemType? { get set }
}

// MARK: - AuthViewModel

final class AuthViewModel: AuthViewModelType {
    // MARK: Dependencies

    private weak var delegate: AuthViewModelDelegate?

    // MARK: State

    @Published var isShowingResetPasswordView = false
    @Published var termItemType: TermItemType? = nil

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: AuthViewModelDelegate? = nil) {
        self.delegate = delegate

        configure()
    }

    private func configure() {}
}

// MARK: SignInViewModelDelegate

extension AuthViewModel: SignInViewModelDelegate {
    func routeToResetPassword() {
        isShowingResetPasswordView = true
    }
}
