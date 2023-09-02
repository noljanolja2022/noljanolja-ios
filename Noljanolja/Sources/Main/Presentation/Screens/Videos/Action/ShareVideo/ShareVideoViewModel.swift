//
//  ShareVideoViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/07/2023.
//
//

import Combine
import Foundation

// MARK: - ShareVideoViewModelDelegate

protocol ShareVideoViewModelDelegate: AnyObject {
    func shareVideoViewModel(didSelectUser user: User)
}

// MARK: - ShareVideoViewModel

final class ShareVideoViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    let action = PassthroughSubject<User, Never>()

    // MARK: Dependencies

    private weak var delegate: ShareVideoViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: ShareVideoViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureActions()
    }

    private func configureActions() {
        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.delegate?.shareVideoViewModel(didSelectUser: $0)
            }
            .store(in: &cancellables)
    }
}
