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
    func getCurrentUser() -> User?
    func getCurrentUserPublisher() -> AnyPublisher<User, Never>
    
    func getCurrentUser() -> AnyPublisher<User, Error>
    func getCurrentUserIfNeeded() -> AnyPublisher<User, Error>

    func updateCurrentUser(_ param: UpdateCurrentUserParam) -> AnyPublisher<User, Error>
    func updateCurrentUserAvatar(_ image: Data?) -> AnyPublisher<User, Error>
}

// MARK: - UserService

final class UserService: UserServiceType {
    static let `default` = UserService()

    // MARK: Dependencies

    private let userAPI: UserAPIType
    private let userStore: UserStoreType

    init(userAPI: UserAPIType = UserAPI.default,
         userStore: UserStoreType = UserStore.default) {
        self.userAPI = userAPI
        self.userStore = userStore
    }

    func getCurrentUser() -> User? {
        userStore.getCurrentUser()
    }

    func getCurrentUserPublisher() -> AnyPublisher<User, Never> {
        userStore.getCurrentUserPublisher()
    }

    func getCurrentUser() -> AnyPublisher<User, Error> {
        userAPI
            .getCurrentUser()
            .handleEvents(receiveOutput: { [weak self] in self?.userStore.saveCurrentUser($0) })
            .eraseToAnyPublisher()
    }

    func getCurrentUserIfNeeded() -> AnyPublisher<User, Error> {
        if getCurrentUser() != nil {
            return userStore
                .getCurrentUserPublisher()
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return userAPI
                .getCurrentUser()
                .handleEvents(receiveOutput: { [weak self] in self?.userStore.saveCurrentUser($0) })
                .eraseToAnyPublisher()
        }
    }

    func updateCurrentUser(_ param: UpdateCurrentUserParam) -> AnyPublisher<User, Error> {
        userAPI
            .updateCurrentUser(param)
            .handleEvents(receiveOutput: { [weak self] in self?.userStore.saveCurrentUser($0) })
            .eraseToAnyPublisher()
    }

    func updateCurrentUserAvatar(_ image: Data?) -> AnyPublisher<User, Error> {
        userAPI
            .updateCurrentUserAvatar(image)
            .flatMap { [weak self] in
                guard let self else {
                    return Empty<User, Error>().eraseToAnyPublisher()
                }
                return self.getCurrentUser()
            }
            .handleEvents(receiveOutput: { [weak self] in self?.userStore.saveCurrentUser($0) })
            .eraseToAnyPublisher()
    }
}
