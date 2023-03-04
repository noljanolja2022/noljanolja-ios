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

protocol RootViewModelType: LaunchScreenViewModelDelegate,
    ViewModelType where State == RootViewModel.State, Action == RootViewModel.Action {}

// MARK: - RootViewModel

extension RootViewModel {
    struct State {
        var contentType: ContentType = .launch

        enum ContentType {
            case launch
            case auth
            case main
        }
    }

    enum Action {}
}

// MARK: - RootViewModel

final class RootViewModel: RootViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private weak var delegate: RootViewModelDelegate?
    private let authService: AuthServicesType

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         delegate: RootViewModelDelegate? = nil,
         authService: AuthServicesType = AuthServices.default) {
        self.state = state
        self.authService = authService
        self.delegate = delegate

        configure()
    }

    func send(_: Action) {}

    private func configure() {
        authService.isAuthenticated
            .dropFirst()
            .removeDuplicates()
            .sink(receiveValue: { [weak self] in
                self?.state.contentType = $0 ? .main : .auth
            })
            .store(in: &cancellables)

//        authService
//            .signOut()
//            .sink(
//                receiveCompletion: { _ in },
//                receiveValue: { _ in }
//            )
//            .store(in: &cancellables)
    }
}

// MARK: LaunchScreenViewModelDelegate

extension RootViewModel: LaunchScreenViewModelDelegate {
    func getLaunchDataFailed() {
        state.contentType = .auth
    }
}
