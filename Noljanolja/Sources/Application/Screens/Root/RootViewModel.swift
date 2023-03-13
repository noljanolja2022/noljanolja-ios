//
//  RootViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import Combine

// MARK: - RootViewModelDelegate

protocol RootViewModelDelegate: AnyObject {}

// MARK: - RootViewModelType

private typealias SubViewModelDelegates = LaunchRootViewModelDelegate & AuthRootViewModelDelegate

// MARK: - RootViewModelType

protocol RootViewModelType: LaunchRootViewModelDelegate,
    AuthRootViewModelDelegate,
    MainViewModelDelegate,
    ViewModelType where State == RootViewModel.State, Action == RootViewModel.Action {}

// MARK: - RootViewModel

extension RootViewModel {
    struct State {
        enum ContentType {
            case launch
            case auth
            case main
        }

        var contentType: ContentType = .launch
    }

    enum Action {}
}

// MARK: - RootViewModel

final class RootViewModel: RootViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private weak var delegate: RootViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         delegate: RootViewModelDelegate? = nil) {
        self.state = state
        self.delegate = delegate

        configure()
    }

    func send(_: Action) {}

    private func configure() {}
}

// MARK: Delegate

extension RootViewModel {
    func navigateToMain() {
        state.contentType = .main
    }
}

// MARK: LaunchRootViewModelDelegate

extension RootViewModel: LaunchRootViewModelDelegate {
    func navigateToAuth() {
        state.contentType = .auth
    }
}

// MARK: AuthRootViewModelDelegate

extension RootViewModel: AuthRootViewModelDelegate {}

// MARK: MainViewModelDelegate

extension RootViewModel: MainViewModelDelegate {
    func didSignOut() {
        state.contentType = .auth
    }
}
