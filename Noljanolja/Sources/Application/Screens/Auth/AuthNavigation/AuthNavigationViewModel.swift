//
//  AuthNavigationViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/02/2023.
//
//

import Combine

// MARK: - AuthNavigationViewModelDelegate

protocol AuthNavigationViewModelDelegate: AnyObject {}

// MARK: - AuthNavigationViewModelType

protocol AuthNavigationViewModelType:
    ViewModelType where State == AuthNavigationViewModel.State, Action == AuthNavigationViewModel.Action {}

extension AuthNavigationViewModel {
    struct State {
        var closePublisher: AnyPublisher<Void, Never> { closeSubject.eraseToAnyPublisher() }

        // MARK: Private

        fileprivate let closeSubject = PassthroughSubject<Void, Never>()
    }

    enum Action {}
}

// MARK: - AuthNavigationViewModel

final class AuthNavigationViewModel: AuthNavigationViewModelType {
    // MARK: Dependencies

    private weak var delegate: AuthNavigationViewModelDelegate?

    // MARK: State

    @Published var state = State()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: AuthNavigationViewModelDelegate? = nil) {
        self.delegate = delegate

        configure()
    }

    private func configure() {}

    func send(_: Action) {}
}

// MARK: AuthViewModelDelegate

extension AuthNavigationViewModel: AuthViewModelDelegate {
    func closeAuthFlow() {
        state.closeSubject.send()
    }
}
