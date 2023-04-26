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
        let method: Moya.Method = .put
        var task: Task { .requestParameters(parameters: param.dictionary, encoding: JSONEncoding.default) }

        let param: UpdateCurrentUserParam
    }

    struct UpdateCurrentUserAvatar: BaseAuthTargetType {
        var path: String { "v1/users/me" }
        let method: Moya.Method = .post
        var task: Task {
            var multipartFormDatas = [MultipartFormData?]()
            if let data = image {
                multipartFormDatas.append(
                    MultipartFormData(provider: .data(data), name: "avatar", fileName: "avatar", mimeType: "image/jpeg")
                )
            }
            return .uploadMultipart(multipartFormDatas.compactMap { $0 })
        }

        let image: Data?
    }

    struct FindUsers: BaseAuthTargetType {
        var path: String { "v1/users" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        let phoneNumber: String

        var parameters: [String: Any] {
            ["phoneNumber": phoneNumber]
        }
    }

    struct GetContacts: BaseAuthTargetType {
        var path: String { "v1/users/me/contacts" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }

        let page: Int
        let pageSize: Int
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
    func updateCurrentUser(_ param: UpdateCurrentUserParam) -> AnyPublisher<User, Error>
    func updateCurrentUserAvatar(_ image: Data?) -> AnyPublisher<Void, Error>

    func findUsers(phoneNumber: String) -> AnyPublisher<[User], Error>
    func getContact(page: Int, pageSize: Int) -> AnyPublisher<[User], Error>
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

    func updateCurrentUser(_ param: UpdateCurrentUserParam) -> AnyPublisher<User, Error> {
        api.request(
            target: UserAPITargets.UpdateCurrentUser(param: param),
            atKeyPath: "data"
        )
    }

    func updateCurrentUserAvatar(_ image: Data?) -> AnyPublisher<Void, Error> {
        api.request(
            target: UserAPITargets.UpdateCurrentUserAvatar(image: image)
        )
    }

    func findUsers(phoneNumber: String) -> AnyPublisher<[User], Error> {
        api.request(
            target: UserAPITargets.FindUsers(phoneNumber: phoneNumber),
            atKeyPath: "data"
        )
    }

    func getContact(page: Int, pageSize: Int) -> AnyPublisher<[User], Error> {
        api.request(
            target: UserAPITargets.GetContacts(page: page, pageSize: pageSize),
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
