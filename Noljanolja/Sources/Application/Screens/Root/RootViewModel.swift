//
//  RootViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import Combine

// MARK: - RootViewModel

final class RootViewModel: ObservableObject {
    // MARK: Dependencies

    private let authService: AuthServicesType

    // MARK: Output

    @Published private(set) var isAuthenticated: Bool
    @Published var isLoading = false

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthServicesType = AuthServices.default) {
        self.authService = authService

        self.isAuthenticated = authService.isAuthenticated.value

        configure()
    }

    private func configure() {
        authService.isAuthenticated
            .sink { [weak self] in self?.isAuthenticated = $0 }
            .store(in: &cancellables)

        AppState.default.$isLoading
            .sink { [weak self] in self?.isLoading = $0 }
            .store(in: &cancellables)
    }
}
