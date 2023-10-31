//
//  UserUseCasesImpls.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//

import Combine
import CombineExt
import Foundation

// MARK: - UserUseCases

protocol UserUseCases {
    func getCurrentUser() -> User?
    func getCurrentUserPublisher() -> AnyPublisher<User, Never>
    
    func getCurrentUser() -> AnyPublisher<User, Error>
    func getCurrentUserIfNeeded() -> AnyPublisher<User, Error>

    func updateCurrentUser(_ param: UpdateCurrentUserParam) -> AnyPublisher<User, Error>
    func updateCurrentUserAvatar(_ image: Data?) -> AnyPublisher<User, Error>
}

// MARK: - UserUseCasesImpl

final class UserUseCasesImpl: UserUseCases {
    static let `default` = UserUseCasesImpl()

    // MARK: Dependencies

    private let userAPI: UserAPIType
    private let localUserRepository: LocalUserRepository

    init(userAPI: UserAPIType = UserAPI.default,
         localUserRepository: LocalUserRepository = LocalUserRepositoryImpl.default) {
        self.userAPI = userAPI
        self.localUserRepository = localUserRepository
    }

    func getCurrentUser() -> User? {
        localUserRepository.getCurrentUser()
    }

    func getCurrentUserPublisher() -> AnyPublisher<User, Never> {
        localUserRepository.getCurrentUserPublisher()
    }

    func getCurrentUser() -> AnyPublisher<User, Error> {
        userAPI
            .getCurrentUser()
            .handleEvents(receiveOutput: { [weak self] in self?.localUserRepository.saveCurrentUser($0) })
            .eraseToAnyPublisher()
    }

    func getCurrentUserIfNeeded() -> AnyPublisher<User, Error> {
        if getCurrentUser() != nil {
            return localUserRepository
                .getCurrentUserPublisher()
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return userAPI
                .getCurrentUser()
                .handleEvents(receiveOutput: { [weak self] in self?.localUserRepository.saveCurrentUser($0) })
                .eraseToAnyPublisher()
        }
    }

    func updateCurrentUser(_ param: UpdateCurrentUserParam) -> AnyPublisher<User, Error> {
        userAPI
            .updateCurrentUser(param)
            .handleEvents(receiveOutput: { [weak self] in self?.localUserRepository.saveCurrentUser($0) })
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
            .handleEvents(receiveOutput: { [weak self] in self?.localUserRepository.saveCurrentUser($0) })
            .eraseToAnyPublisher()
    }
}
