//
//  ProfileViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import Combine
import Foundation

// MARK: - ProfileViewModelDelegate

protocol ProfileViewModelDelegate: AnyObject {
    func didSignOut()
}

// MARK: - ProfileViewModel

final class ProfileViewModel: ViewModel {
    // MARK: State

    @Published var user: User?

    // MARK: Navigations

    @Published var navigationType: ProfileNavigationType?

    // MARK: Action

    // MARK: Dependencies

    private let userService: UserServiceType
    private weak var delegate: ProfileViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(userService: UserServiceType = UserService.default,
         delegate: ProfileViewModelDelegate? = nil) {
        self.userService = userService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        userService.currentUserPublisher
            .sink(receiveValue: { [weak self] in self?.user = $0 })
            .store(in: &cancellables)
    }
}

// MARK: SettingViewModelDelegate

extension ProfileViewModel: SettingViewModelDelegate {
    func didSignOut() {
        delegate?.didSignOut()
    }
}
