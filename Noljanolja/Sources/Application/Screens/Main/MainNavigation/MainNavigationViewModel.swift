//
//  MainNavigationViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/02/2023.
//
//

import Combine

// MARK: - MainNavigationViewModelDelegate

protocol MainNavigationViewModelDelegate: AnyObject {}

// MARK: - MainNavigationViewModelType

protocol MainNavigationViewModelType: ObservableObject {
    // MARK: State

    // MARK: Action
}

// MARK: - MainNavigationViewModel

final class MainNavigationViewModel: MainNavigationViewModelType {
    // MARK: Dependencies

    private weak var delegate: MainNavigationViewModelDelegate?

    // MARK: State

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: MainNavigationViewModelDelegate? = nil) {
        self.delegate = delegate

        configure()
    }

    private func configure() {}
}
