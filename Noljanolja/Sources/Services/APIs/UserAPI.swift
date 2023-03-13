//
//  HomeAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Combine
import Foundation
import Moya

// MARK: - UserAPITargets

private enum UserAPITargets {
    struct GetCurrentUser: BaseAuthTargetType {
        var path: String { "v1/users/me" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }
    }

    struct UpdateCurrentUser: BaseAuthTargetType {
        var path: String { "v1/users/me" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }

        let param: UpdateCurrentUserParam
    }
    
    struct SyncContacts: BaseAuthTargetType {
        var path: String { "v1/users/me/contacts" }
        let method: Moya.Method = .post
        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }

        let contacts: [Contact]

        var parameters: [String: Any] {
            ["contacts": contacts.map { $0.dictionary }]
        }
    }
}

// MARK: - UserAPIType

protocol UserAPIType {
    func getCurrentUser() -> AnyPublisher<User, Error>
    func updateCurrentUser() -> AnyPublisher<User, Error>
    func syncContacts(_ contacts: [Contact]) -> AnyPublisher<[User], Error>
}

// MARK: - UserAPI

final class UserAPI: UserAPIType {
    static let `default` = UserAPI()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getCurrentUser() -> AnyPublisher<User, Error> {
        api.request(
            target: UserAPITargets.GetCurrentUser(),
            atKeyPath: "data"
        )
    }

    func updateCurrentUser() -> AnyPublisher<User, Error> {
        api.request(
            target: UserAPITargets.GetCurrentUser(),
            atKeyPath: "data"
        )
    }

    func syncContacts(_ contacts: [Contact]) -> AnyPublisher<[User], Error> {
        api.request(
            target: UserAPITargets.SyncContacts(contacts: contacts),
            atKeyPath: "data"
        )
    }
}
