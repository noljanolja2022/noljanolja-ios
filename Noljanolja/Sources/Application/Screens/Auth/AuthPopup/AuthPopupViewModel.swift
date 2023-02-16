//
//  AuthPopupViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/02/2023.
//
//

import Combine

// MARK: - AuthPopupViewModelDelegate

protocol AuthPopupViewModelDelegate: AnyObject {
    func routeToAuth()
}

// MARK: - AuthPopupViewModelType

protocol AuthPopupViewModelType: ObservableObject {
    // MARK: State

    // MARK: Action

    var routeToAuthTrigger: PassthroughSubject<Void, Never> { get }
}

// MARK: - AuthPopupViewModel

final class AuthPopupViewModel: AuthPopupViewModelType {
    // MARK: Dependencies

    private weak var delegate: AuthPopupViewModelDelegate?

    // MARK: State

    // MARK: Action

    let routeToAuthTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: AuthPopupViewModelDelegate? = nil) {
        self.delegate = delegate

        configure()
    }

    private func configure() {
        routeToAuthTrigger
            .sink(receiveValue: { [weak self] in self?.delegate?.routeToAuth() })
            .store(in: &cancellables)
    }
}
