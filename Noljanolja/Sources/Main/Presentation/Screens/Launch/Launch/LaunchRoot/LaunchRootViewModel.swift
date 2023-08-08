//
//  LaunchRootViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import Combine
import Foundation

// MARK: - LaunchRootViewModelDelegate

protocol LaunchRootViewModelDelegate: AnyObject {
    func launchRootViewModelDidComplete(_ user: User?)
}

// MARK: - LaunchRootViewModel

final class LaunchRootViewModel: ViewModel {
    // MARK: State

    @Published var contentType: LaunchRootBodyType = .launch

    // MARK: Dependencies

    private weak var delegate: LaunchRootViewModelDelegate?

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: LaunchRootViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}

// MARK: LaunchViewModelDelegate

extension LaunchRootViewModel: LaunchViewModelDelegate {
    func launchViewModelDidComplete(_ user: User?) {
        delegate?.launchRootViewModelDidComplete(user)
    }
}
