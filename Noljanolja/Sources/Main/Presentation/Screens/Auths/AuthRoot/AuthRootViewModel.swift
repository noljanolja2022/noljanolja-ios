//
//  AuthRootViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import Combine
import Foundation

// MARK: - AuthRootViewModelDelegate

protocol AuthRootViewModelDelegate: AnyObject {
    func authRootViewModelDidComplete(_ user: User)
}

// MARK: - AuthRootViewModel

final class AuthRootViewModel: ViewModel {
    // MARK: State

    @Published var contentType: AuthRootBodyType = .auth

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: AuthRootViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: AuthRootViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}

// MARK: TermViewModelDelegate

extension AuthRootViewModel: TermViewModelDelegate {
    func termViewModelDidComplete() {
        contentType = .userConfiguration
    }
}

// MARK: AuthViewModelDelegate

extension AuthRootViewModel: AuthViewModelDelegate {
    func authViewModelDidComplete(_ user: User) {
        delegate?.authRootViewModelDidComplete(user)
    }
}

// MARK: Auth2ViewModelDelegate

extension AuthRootViewModel: Auth2ViewModelDelegate {
    func googleAuthViewModelDidComplete(_ user: User) {
        delegate?.authRootViewModelDidComplete(user)
    }
}

// MARK: UserConfigurationRootViewModelDelegate

extension AuthRootViewModel: UserConfigurationRootViewModelDelegate {
    func userConfigurationRootViewModelDidComplete() {
//        contentType = .main
    }
}
