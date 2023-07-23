//
//  NotificationService.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/03/2023.
//

import Combine
import Foundation
import UserNotifications

// MARK: - NotificationServiceType

protocol NotificationServiceType {
    func sendPushToken(token: String)
}

// MARK: - NotificationService

final class NotificationService: NotificationServiceType {
    static let `default` = NotificationService()

    private let userStore: UserStoreType
    private let notificationAPI: NotificationAPIType

    private let pushTokenSubject = PassthroughSubject<String, Never>()

    private var cancellables = Set<AnyCancellable>()

    private init(userStore: UserStoreType = UserStore.default,
                 notificationAPI: NotificationAPIType = NotificationAPI.default) {
        self.userStore = userStore
        self.notificationAPI = notificationAPI

        configure()
    }

    private func configure() {
        Publishers.CombineLatest(
            userStore.getCurrentUserPublisher(),
            pushTokenSubject
                .removeDuplicates()
                .filter { !$0.trimmed.isEmpty }
        )
        .flatMapLatestToResult { [weak self] _, token in
            guard let self else {
                return Empty<Void, Error>().eraseToAnyPublisher()
            }
            return self.notificationAPI
                .sendPushToken(deviceToken: token)
        }
        .sink(receiveValue: { _ in })
        .store(in: &cancellables)
    }

    func sendPushToken(token: String) {
        pushTokenSubject.send(token)
    }
}
