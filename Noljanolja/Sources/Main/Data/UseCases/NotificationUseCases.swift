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
    func getNotifications(page: Int, pageSize: Int) -> AnyPublisher<[NotificationsModel], Error>
}

// MARK: - NotificationUseCasesImpl

final class NotificationUseCasesImpl: NotificationUseCases {
    static let `default` = NotificationUseCasesImpl()

    private let userLocalRepository: UserLocalRepository
    private let notificationNetworkRepository: NotificationNetworkRepository

    private let pushTokenSubject = PassthroughSubject<String, Never>()

    private var cancellables = Set<AnyCancellable>()

    private init(userLocalRepository: UserLocalRepository = UserLocalRepositoryImpl.default,
                 notificationNetworkRepository: NotificationNetworkRepository = NotificationNetworkRepositoryImpl.shared) {
        self.userLocalRepository = userLocalRepository
        self.notificationNetworkRepository = notificationNetworkRepository

        configure()
    }

    private func configure() {
        Publishers.CombineLatest(
            userLocalRepository.getCurrentUserPublisher(),
            pushTokenSubject
                .removeDuplicates()
                .filter { !$0.trimmed.isEmpty }
        )
        .flatMapLatestToResult { [weak self] _, token in
            guard let self else {
                return Empty<Void, Error>().eraseToAnyPublisher()
            }
            return self.notificationNetworkRepository
                .sendPushToken(deviceToken: token)
        }
        .sink(receiveValue: { _ in })
        .store(in: &cancellables)
    }

    func sendPushToken(token: String) {
        pushTokenSubject.send(token)
    }

    func deletePushToken() -> AnyPublisher<Void, Error> {
        notificationNetworkRepository
            .sendPushToken(deviceToken: "")
    }
    
    func getNotifications(page: Int, pageSize: Int) -> AnyPublisher<[NotificationsModel], Error> {
        notificationNetworkRepository
            .getNotificaionts(page: page, pageSize: pageSize)
    }
}
