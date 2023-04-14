//
//  MainViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import Combine
import Foundation

// MARK: - MainViewModelDelegate

protocol MainViewModelDelegate: AnyObject {
    func didSignOut()
}

// MARK: - MainViewModel

final class MainViewModel: ViewModel {
    // MARK: State

    @Published var selectedTab = MainTabType.chat

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: MainViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: MainViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}

// MARK: ProfileViewModelDelegate

extension MainViewModel: ProfileViewModelDelegate {
    func didSignOut() {
        delegate?.didSignOut()
    }
}
