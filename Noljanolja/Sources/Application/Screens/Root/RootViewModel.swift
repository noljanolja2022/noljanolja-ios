//
//  RootViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import Combine
import Foundation

// MARK: - RootViewModelDelegate

protocol RootViewModelDelegate: AnyObject {}

// MARK: - RootViewModel

final class RootViewModel: ViewModel {
    // MARK: State

    @Published var contentType: RootBodyType = .launch

    // MARK: Action

    private let requestNotificationPermissionAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let notificationService: NotificationServiceType
    private weak var delegate: RootViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(notificationService: NotificationServiceType = NotificationService.default,
         delegate: RootViewModelDelegate? = nil) {
        self.notificationService = notificationService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        requestNotificationPermissionAction
            .first()
            .sink(receiveValue: { [weak self] in
                self?.notificationService.requestPermission()
            })
            .store(in: &cancellables)
    }
}

// MARK: Delegate

extension RootViewModel {
    func navigateToMain() {
        contentType = .main
    }
}

// MARK: LaunchRootViewModelDelegate

extension RootViewModel: LaunchRootViewModelDelegate {
    func navigateToAuth() {
        contentType = .auth
    }
}

// MARK: AuthRootViewModelDelegate

extension RootViewModel: AuthRootViewModelDelegate {}

// MARK: MainViewModelDelegate

extension RootViewModel: MainViewModelDelegate {
    func didSignOut() {
        contentType = .auth
    }
}
