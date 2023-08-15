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
    func termViewModelDidComplete() {
        contentType = .auth
    }
}

// MARK: AuthViewModelDelegate

extension AuthRootViewModel: AuthViewModelDelegate {
    func authViewModelDidComplete(_ user: User) {
        delegate?.authRootViewModelDidComplete(user)
    }
}
