//
//  MainViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/02/2023.
//
//

import Combine

// MARK: - MainViewModelDelegate

protocol MainViewModelDelegate: AnyObject {}

// MARK: - MainViewModelType

protocol MainViewModelType: ObservableObject {
    // MARK: State

    var selectedTabItem: TabBarItem { get set }

    // MARK: Action
}

// MARK: - MainViewModel

final class MainViewModel: MainViewModelType {
    // MARK: Dependencies

    private weak var delegate: MainViewModelDelegate?

    // MARK: State

    @Published var selectedTabItem: TabBarItem = .home

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: MainViewModelDelegate? = nil) {
        self.delegate = delegate

        configure()
    }

    private func configure() {}
}
