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
    var isAuthenticatedPublisher: AnyPublisher<Bool, Never> { get }
}

// MARK: - RootViewModel

final class RootViewModel: RootViewModelType {
    // MARK: Dependencies

    private weak var delegate: RootViewModelDelegate?
    private let authService: AuthServicesType

    // MARK: State

    var isAuthenticatedPublisher: AnyPublisher<Bool, Never> { isAuthenticatedSubject.eraseToAnyPublisher() }
    let isAuthenticatedSubject = PassthroughSubject<Bool, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: RootViewModelDelegate? = nil,
         authService: AuthServicesType = AuthServices.default) {
        self.delegate = delegate
        self.authService = authService

        configure()
    }

    private func configure() {
        authService.isAuthenticated
            .dropFirst()
            .removeDuplicates()
            .sink(receiveValue: { [weak self] in self?.isAuthenticatedSubject.send($0) })
            .store(in: &cancellables)
    }
}
