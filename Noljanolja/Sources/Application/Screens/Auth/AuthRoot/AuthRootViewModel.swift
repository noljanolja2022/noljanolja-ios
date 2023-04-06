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

// MARK: - AuthRootViewModelType

protocol AuthRootViewModelType: TermViewModelDelegate,
    AuthViewModelDelegate,
    UpdateCurrentUserViewModelDelegate,
    ViewModelType where State == AuthRootViewModel.State, Action == AuthRootViewModel.Action {}

extension AuthRootViewModel {
    struct State {
        enum ContentType {
            case terms
            case auth
            case updateCurrentUser
        }

        var contentType: ContentType = .terms
    }

    enum Action {}
}

// MARK: - AuthRootViewModel

final class AuthRootViewModel: AuthRootViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private weak var delegate: AuthRootViewModelDelegate?

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         delegate: AuthRootViewModelDelegate? = nil) {
        self.state = state
        self.delegate = delegate

        configure()
    }

    func send(_: Action) {}

    private func configure() {}
}

// MARK: TermViewModelDelegate

extension AuthRootViewModel: TermViewModelDelegate {
    func navigateToAuth() {
        state.contentType = .auth
    }
}

// MARK: AuthViewModelDelegate

extension AuthRootViewModel: AuthViewModelDelegate {
    func navigateToMain() {
        delegate?.navigateToMain()
    }

    func navigateToUpdateCurrentUser() {
        state.contentType = .updateCurrentUser
    }
}

// MARK: UpdateCurrentUserViewModelDelegate

extension AuthRootViewModel: UpdateCurrentUserViewModelDelegate {
    func didUpdateCurrentUser() {
        delegate?.navigateToMain()
    }
}
