//
//  NotificationUseCasesImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/03/2023.
//

import Combine
import Foundation
import UserNotifications

// MARK: - NotificationUseCases

protocol NotificationUseCases {
    func sendPushToken(token: String)
    func deletePushToken() -> AnyPublisher<Void, Error>
}

// MARK: - NotificationUseCasesImpl

final class NotificationUseCasesImpl: NotificationUseCases {
    static let `default` = NotificationUseCasesImpl()

    private let userStore: UserStoreType
    private let networkNotificationRepository: NetworkNotificationRepository

    private let pushTokenSubject = PassthroughSubject<String, Never>()

    private var cancellables = Set<AnyCancellable>()

    private init(userStore: UserStoreType = UserStore.default,
                 networkNotificationRepository: NetworkNotificationRepository = NetworkNotificationRepositoryImpl.shared) {
        self.userStore = userStore
        self.networkNotificationRepository = networkNotificationRepository

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
            return self.networkNotificationRepository
                .sendPushToken(deviceToken: token)
        }
        .sink(receiveValue: { _ in })
        .store(in: &cancellables)
    }

    func sendPushToken(token: String) {
        pushTokenSubject.send(token)
    }

    func deletePushToken() -> AnyPublisher<Void, Error> {
        networkNotificationRepository
            .sendPushToken(deviceToken: "")
    }
}
