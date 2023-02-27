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

protocol RootViewModelType: ObservableObject {
    var isAuthenticated: Bool { get }
}

// MARK: - RootViewModel

final class RootViewModel: RootViewModelType {
    // MARK: Dependencies

    private weak var delegate: RootViewModelDelegate?
    private let authService: AuthServicesType

    // MARK: Output

    @Published private(set) var isAuthenticated: Bool

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: RootViewModelDelegate? = nil,
         authService: AuthServicesType = AuthServices.default) {
        self.delegate = delegate
        self.authService = authService

        self.isAuthenticated = authService.isAuthenticated.value

        configure()
    }

    private func configure() {
        authService.isAuthenticated
            .sink { [weak self] in self?.isAuthenticated = $0 }
            .store(in: &cancellables)
    }
}
