//
//  UserServices.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//

import Combine
import CombineExt
import Foundation

// MARK: - UserServiceType

protocol UserServiceType {
    func getCurrentUser() -> AnyPublisher<User, Error>
    func getCurrentUserIfNeeded() -> AnyPublisher<User, Error>
}

// MARK: - UserService

final class UserService: UserServiceType {
    static let `default` = UserService()

    // MARK: Dependencies

    private let userAPI: UserAPIType

    // MARK: Date

    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)

    init(userAPI: UserAPIType = UserAPI.default) {
        self.userAPI = userAPI
    }

    func getCurrentUser() -> AnyPublisher<User, Error> {
        userAPI
            .getCurrentUser()
            .handleEvents(receiveOutput: { [weak self] in self?.currentUserSubject.send($0) })
            .eraseToAnyPublisher()
    }

    func getCurrentUserIfNeeded() -> AnyPublisher<User, Error> {
        currentUserSubject.eraseToAnyPublisher()
            .flatMap { [weak self] user in
                guard let self else {
                    return Empty<User, Error>().eraseToAnyPublisher()
                }
                if let user {
                    return Just(user).setFailureType(to: Error.self).eraseToAnyPublisher()
                } else {
                    return self.getCurrentUser()
                }
            }
            .eraseToAnyPublisher()
    }
}
