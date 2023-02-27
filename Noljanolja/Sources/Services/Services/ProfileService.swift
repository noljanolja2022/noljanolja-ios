//
//  ProfileServices.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//

import Combine
import Foundation

// MARK: - ProfileServiceType

protocol ProfileServiceType {
    func getProfile() -> AnyPublisher<ProfileModel, Error>
}

// MARK: - ProfileService

final class ProfileService: ProfileServiceType {
    private let profileAPI: ProfileAPIType

    init(profileAPI: ProfileAPIType = ProfileAPI()) {
        self.profileAPI = profileAPI
    }

    func getProfile() -> AnyPublisher<ProfileModel, Error> {
        profileAPI.getProfile()
    }
}
