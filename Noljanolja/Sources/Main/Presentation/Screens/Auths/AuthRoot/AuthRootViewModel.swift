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
    func navigateToMain()
}

// MARK: - AuthRootViewModel

final class AuthRootViewModel: ViewModel {
    // MARK: State

    @Published var contentType: AuthRootBodyType = .terms

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
    func navigateToAuth() {
        contentType = .auth
    }
}

// MARK: AuthViewModelDelegate

extension AuthRootViewModel: AuthViewModelDelegate {
    func navigateToMain() {
        delegate?.navigateToMain()
    }

    func navigateToUpdateCurrentUser() {
        contentType = .updateCurrentUser
    }
}

// MARK: UpdateCurrentUserViewModelDelegate

extension AuthRootViewModel: UpdateCurrentUserViewModelDelegate {
    func didUpdateCurrentUser() {
        delegate?.navigateToMain()
    }
}
