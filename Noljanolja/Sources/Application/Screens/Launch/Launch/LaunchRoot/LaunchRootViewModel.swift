//
//  LaunchRootViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import Combine
import Foundation

// MARK: - LaunchRootViewModelDelegate

protocol LaunchRootViewModelDelegate: AnyObject {
    func navigateToAuth()
    func navigateToMain()
}

// MARK: - LaunchRootViewModelType

protocol LaunchRootViewModelType: LaunchViewModelDelegate,
    UpdateCurrentUserViewModelDelegate,
    ViewModelStateGetOnlyType where State == LaunchRootViewModel.State, Action == LaunchRootViewModel.Action {}

extension LaunchRootViewModel {
    struct State {
        enum ContentType {
            case launch
            case updateCurrentUser
        }

        var contentType: ContentType = .launch
    }

    enum Action {}
}

// MARK: - LaunchRootViewModel

final class LaunchRootViewModel: LaunchRootViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private weak var delegate: LaunchRootViewModelDelegate?

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         delegate: LaunchRootViewModelDelegate? = nil) {
        self.state = state
        self.delegate = delegate

        configure()
    }

    func send(_: Action) {}

    private func configure() {}
}

// MARK: LaunchViewModelDelegate

extension LaunchRootViewModel: LaunchViewModelDelegate {
    func navigateToAuth() {
        delegate?.navigateToAuth()
    }

    func navigateToUpdateCurrentUser() {
        state.contentType = .updateCurrentUser
    }

    func navigateToMain() {
        delegate?.navigateToMain()
    }
}

// MARK: UpdateCurrentUserViewModelDelegate

extension LaunchRootViewModel: UpdateCurrentUserViewModelDelegate {
    func didUpdateCurrentUser() {
        delegate?.navigateToMain()
    }
}
