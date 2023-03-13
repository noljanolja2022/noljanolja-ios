//
//  ProfileServices.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//

import Combine
import CombineExt
import Foundation

// MARK: - ProfileServiceType

protocol ProfileServiceType {
    func getProfile() -> AnyPublisher<User, Error>
    func getProfileIfNeeded() -> AnyPublisher<User, Error>
}

// MARK: - ProfileService

final class ProfileService: ProfileServiceType {
    static let `default` = ProfileService()

    // MARK: Dependencies

    private let profileAPI: ProfileAPIType

    // MARK: Date

    private let profileModelSubject = CurrentValueSubject<User?, Never>(nil)

    init(profileAPI: ProfileAPIType = ProfileAPI()) {
        self.profileAPI = profileAPI
    }

    func getProfile() -> AnyPublisher<User, Error> {
        profileAPI
            .getProfile()
            .handleEvents(receiveOutput: { [weak self] in self?.profileModelSubject.send($0) })
            .eraseToAnyPublisher()
    }

    func getProfileIfNeeded() -> AnyPublisher<User, Error> {
        profileModelSubject.eraseToAnyPublisher()
            .flatMap { [weak self] user in
                guard let self else {
                    return Empty<User, Error>().eraseToAnyPublisher()
                }
                if let user {
                    return Just(user).setFailureType(to: Error.self).eraseToAnyPublisher()
                } else {
                    return self.getProfile()
                }
            }
            .eraseToAnyPublisher()
    }
}
