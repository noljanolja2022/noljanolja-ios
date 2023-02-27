//
//  HomeAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Combine
import Foundation
import Moya

// MARK: - ProfileAPITargets

private enum ProfileAPITargets {
    struct GetProfile: BaseAuthTargetType {
        var path: String { "v1/users/me" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }
    }
}

// MARK: - ProfileAPIType

protocol ProfileAPIType {
    func getProfile() -> AnyPublisher<ProfileModel, Error>
}

// MARK: - ProfileAPI

final class ProfileAPI: ProfileAPIType {
    private let api: ApiType = Api.default

    func getProfile() -> AnyPublisher<ProfileModel, Error> {
        api.request(
            target: ProfileAPITargets.GetProfile(),
            atKeyPath: "data"
        )
    }
}
