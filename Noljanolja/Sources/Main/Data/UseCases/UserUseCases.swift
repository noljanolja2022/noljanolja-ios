//
//  UserUseCasesImpls.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//

import Combine
import CombineExt
import Foundation
import SDWebImage

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

    private let userNetworkRepository: UserNetworkRepository
    private let userLocalRepository: UserLocalRepository

    init(userNetworkRepository: UserNetworkRepository = UserNetworkRepositoryImpl.default,
         userLocalRepository: UserLocalRepository = UserLocalRepositoryImpl.default) {
        self.userNetworkRepository = userNetworkRepository
        self.userLocalRepository = userLocalRepository
    }

    func getCurrentUser() -> User? {
        userLocalRepository.getCurrentUser()
    }

    func getCurrentUserPublisher() -> AnyPublisher<User, Never> {
        userLocalRepository.getCurrentUserPublisher()
    }

    func getCurrentUser() -> AnyPublisher<User, Error> {
        userNetworkRepository
            .getCurrentUser()
            .handleEvents(receiveOutput: { [weak self] in self?.userLocalRepository.saveCurrentUser($0) })
            .eraseToAnyPublisher()
    }

    func getCurrentUserIfNeeded() -> AnyPublisher<User, Error> {
        if getCurrentUser() != nil {
            return userLocalRepository
                .getCurrentUserPublisher()
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return userNetworkRepository
                .getCurrentUser()
                .handleEvents(receiveOutput: { [weak self] in self?.userLocalRepository.saveCurrentUser($0) })
                .eraseToAnyPublisher()
        }
    }

    func updateCurrentUser(_ param: UpdateCurrentUserParam) -> AnyPublisher<User, Error> {
        userNetworkRepository
            .updateCurrentUser(param)
            .handleEvents(receiveOutput: { [weak self] in self?.userLocalRepository.saveCurrentUser($0) })
            .eraseToAnyPublisher()
    }

    func updateCurrentUserAvatar(_ image: Data?) -> AnyPublisher<User, Error> {
        userNetworkRepository
            .updateCurrentUserAvatar(image)
            .flatMap { [weak self] in
                guard let self else {
                    return Empty<User, Error>().eraseToAnyPublisher()
                }
                SDWebImageManager.shared.imageCache.clear?(with: .all)
                return self.getCurrentUser()
            }
            .handleEvents(receiveOutput: { [weak self] in self?.userLocalRepository.saveCurrentUser($0) })
            .eraseToAnyPublisher()
    }
}
