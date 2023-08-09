//
//  UserConfigurationRootViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/08/2023.
//
//

import Combine
import Foundation

// MARK: - UserConfigurationRootViewModelDelegate

protocol UserConfigurationRootViewModelDelegate: AnyObject {
    func userConfigurationRootViewModelDidComplete()
}

// MARK: - UserConfigurationRootViewModel

final class UserConfigurationRootViewModel: ViewModel {
    // MARK: State

    @Published var contentType: UserConfigurationRootBodyType = .updateCurrentUser

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: UserConfigurationRootViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: UserConfigurationRootViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}

// MARK: UpdateCurrentUserViewModelDelegate

extension UserConfigurationRootViewModel: UpdateCurrentUserViewModelDelegate {
    func didUpdateCurrentUser() {
        contentType = .referral
    }
}

// MARK: AddReferralViewModelDelegate

extension UserConfigurationRootViewModel: AddReferralViewModelDelegate {
    func addReferralViewModelDidComplete() {
        delegate?.userConfigurationRootViewModelDidComplete()
    }
}
