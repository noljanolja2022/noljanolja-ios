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
    func getProfile() -> AnyPublisher<ProfileModel, Error>
    func getProfileIfNeeded() -> AnyPublisher<ProfileModel, Error>
}

// MARK: - ProfileService

final class ProfileService: ProfileServiceType {
    static let `default` = ProfileService()

    // MARK: Dependencies

    private let profileAPI: ProfileAPIType

    // MARK: Date

    private let profileModelSubject = CurrentValueSubject<ProfileModel?, Never>(nil)

    init(profileAPI: ProfileAPIType = ProfileAPI()) {
        self.profileAPI = profileAPI
    }

    func getProfile() -> AnyPublisher<ProfileModel, Error> {
        profileAPI
            .getProfile()
            .handleEvents(receiveOutput: { [weak self] in self?.profileModelSubject.send($0) })
            .eraseToAnyPublisher()
    }

    func getProfileIfNeeded() -> AnyPublisher<ProfileModel, Error> {
        profileModelSubject.eraseToAnyPublisher()
            .flatMap { [weak self] profileModel in
                guard let self else {
                    return Empty<ProfileModel, Error>().eraseToAnyPublisher()
                }
                if let profileModel {
                    return Just(profileModel).setFailureType(to: Error.self).eraseToAnyPublisher()
                } else {
                    return self.getProfile()
                }
            }
            .eraseToAnyPublisher()
    }
}
