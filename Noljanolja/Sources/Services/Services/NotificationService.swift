//
//  NotificationService.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/03/2023.
//

import Combine
import Foundation

// MARK: - NotificationServiceType

protocol NotificationServiceType {
    func sendPushToken(token: String)
}

// MARK: - NotificationService

final class NotificationService: NotificationServiceType {
    static let `default` = NotificationService()

    private let userService: UserServiceType
    private let notificationAPI: NotificationAPIType

    private let currentUserSubject = PassthroughSubject<User, Never>()
    private let pushTokenSubject = PassthroughSubject<String, Never>()

    private var cancellables = Set<AnyCancellable>()

    private init(userService: UserServiceType = UserService.default,
                 notificationAPI: NotificationAPIType = NotificationAPI.default) {
        self.userService = userService
        self.notificationAPI = notificationAPI

        configure()
    }

    private func configure() {
        Publishers
            .CombineLatest(
                currentUserSubject.removeDuplicates(),
                pushTokenSubject.removeDuplicates()
            )
            .flatMapLatestToResult { [weak self] user, token in
                guard let self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }
                return self.notificationAPI
                    .sendPushToken(userId: user.id, deviceToken: token)
            }
            .sink(receiveValue: { _ in })
            .store(in: &cancellables)

        userService.currentUserPublisher
            .sink(receiveValue: { [weak self] in self?.currentUserSubject.send($0) })
            .store(in: &cancellables)
    }

    func sendPushToken(token: String) {
        pushTokenSubject.send(token)
    }
}
