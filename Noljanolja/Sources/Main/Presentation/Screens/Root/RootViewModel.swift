//
//  RootViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import Combine
import Foundation

// MARK: - RootViewModelDelegate

protocol RootViewModelDelegate: AnyObject {}

// MARK: - RootViewModel

final class RootViewModel: ViewModel {
    // MARK: State

    @Published var contentType: RootBodyType = .launch

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: RootViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: RootViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}

// MARK: Delegate

extension RootViewModel {
    func checkUser(_ user: User?) {
        if let user {
            if user.isSettedUp {
                contentType = .main
            } else {
                contentType = .term
            }
        } else {
            contentType = .auth
        }
    }
}

// MARK: LaunchRootViewModelDelegate

extension RootViewModel: LaunchRootViewModelDelegate {
    func launchRootViewModelDidComplete(_ user: User?) {
        checkUser(user)
    }
}

// MARK: AuthRootViewModelDelegate

extension RootViewModel: AuthRootViewModelDelegate {
    func authRootViewModelDidComplete(_ user: User) {
        checkUser(user)
    }
}

// MARK: UserConfigurationRootViewModelDelegate

extension RootViewModel: UserConfigurationRootViewModelDelegate {
    func userConfigurationRootViewModelDidComplete() {
        contentType = .main
    }
}

// MARK: MainViewModelDelegate

extension RootViewModel: MainViewModelDelegate {
    func mainViewModelSignOut() {
        contentType = .auth
    }
}

// MARK: TermViewModelDelegate

extension RootViewModel: TermViewModelDelegate {
    func termViewModelDidComplete() {
        contentType = .userConfiguraction
    }
}
