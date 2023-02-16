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

protocol AuthNavigationViewModelType: ObservableObject {}

// MARK: - AuthNavigationViewModel

final class AuthNavigationViewModel: AuthNavigationViewModelType {
    // MARK: Dependencies

    private weak var delegate: AuthNavigationViewModelDelegate?

    // MARK: State

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: AuthNavigationViewModelDelegate? = nil) {
        self.delegate = delegate

        configure()
    }

    private func configure() {}
}
