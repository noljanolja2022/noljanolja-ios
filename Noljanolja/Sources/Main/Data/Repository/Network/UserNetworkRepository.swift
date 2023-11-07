//
//  HomeAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Combine
import Foundation
import Moya

// MARK: - UserTargets

private enum UserTargets {
    struct GetCurrentUser: BaseAuthTargetType {
        var path: String { "v1/users/me" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }
    }

    struct UpdateCurrentUser: BaseAuthTargetType {
        var path: String { "v1/users/me" }
        let method: Moya.Method = .put
        var task: Task { .requestParameters(parameters: param.json, encoding: JSONEncoding.default) }

        let param: UpdateCurrentUserParam
    }

    struct UpdateCurrentUserAvatar: BaseAuthTargetType {
        var path: String { "v1/users/me" }
        let method: Moya.Method = .post
        var task: Task {
            var multipartFormDatas = [MultipartFormData?]()
            if let fieldData = "AVATAR".data(using: .utf8), let fileData = image {
                multipartFormDatas.append(
                    MultipartFormData(provider: .data(fieldData), name: "field")
                )
                multipartFormDatas.append(
                    MultipartFormData(provider: .data(fileData), name: "files", fileName: "avatar", mimeType: "image/jpeg")
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

        let phoneNumber: String?
        let friendId: String?

        var parameters: [String: Any] {
            [
                "phoneNumber": phoneNumber,
                "friendId": friendId
            ]
            .compactMapValues { $0 }
        }
    }

    struct GetContacts: BaseAuthTargetType {
        var path: String { "v1/users/me/contacts" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }

        let page: Int
        let pageSize: Int
    }
    
    struct SyncContacts: BaseAuthTargetType, RequestTimeoutConfigurable {
        var path: String { "v1/users/me/contacts" }
        let method: Moya.Method = .post
        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }
        var timeout: TimeInterval = 120

        let contacts: [Contact]

        var parameters: [String: Any] {
            ["contacts": contacts.map { $0.json }]
        }
    }

    struct InviteUser: BaseAuthTargetType {
        var path: String { "v1/users/me/contacts/invite" }
        let method: Moya.Method = .post
        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }

        let id: String

        var parameters: [String: Any] {
            ["friendId": id]
        }
    }

    struct AddReferral: BaseAuthTargetType {
        var path: String { "v1/users/me/referral" }
        let method: Moya.Method = .put
        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }

        let referredByCode: String

        var parameters: [String: Any] {
            ["referredByCode": referredByCode]
        }
    }
}

// MARK: - UserNetworkRepository

protocol UserNetworkRepository {
    func getCurrentUser() -> AnyPublisher<User, Error>
    func updateCurrentUser(_ param: UpdateCurrentUserParam) -> AnyPublisher<User, Error>
    func updateCurrentUserAvatar(_ image: Data?) -> AnyPublisher<Void, Error>

    func findUsers(phoneNumber: String?, friendId: String?) -> AnyPublisher<[User], Error>
    func getContact(page: Int, pageSize: Int) -> AnyPublisher<[User], Error>
    func syncContacts(_ contacts: [Contact]) -> AnyPublisher<[User], Error>
    func inviteUser(id: String) -> AnyPublisher<Void, Error>
    func addReferral(referredByCode: String) -> AnyPublisher<Int, Error>
}

// MARK: - UserNetworkRepositoryImpl

final class UserNetworkRepositoryImpl: UserNetworkRepository {
    static let `default` = UserNetworkRepositoryImpl()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getCurrentUser() -> AnyPublisher<User, Error> {
        api.request(
            target: UserTargets.GetCurrentUser(),
            atKeyPath: "data"
        )
    }

    func updateCurrentUser(_ param: UpdateCurrentUserParam) -> AnyPublisher<User, Error> {
        api.request(
            target: UserTargets.UpdateCurrentUser(param: param),
            atKeyPath: "data"
        )
    }

    func updateCurrentUserAvatar(_ image: Data?) -> AnyPublisher<Void, Error> {
        api.request(
            target: UserTargets.UpdateCurrentUserAvatar(image: image)
        )
    }

    func findUsers(phoneNumber: String?, friendId: String?) -> AnyPublisher<[User], Error> {
        api.request(
            target: UserTargets.FindUsers(phoneNumber: phoneNumber, friendId: friendId),
            atKeyPath: "data"
        )
    }

    func getContact(page: Int, pageSize: Int) -> AnyPublisher<[User], Error> {
        api.request(
            target: UserTargets.GetContacts(page: page, pageSize: pageSize),
            atKeyPath: "data"
        )
    }

    func syncContacts(_ contacts: [Contact]) -> AnyPublisher<[User], Error> {
        api.request(
            target: UserTargets.SyncContacts(contacts: contacts),
            atKeyPath: "data"
        )
    }

    func inviteUser(id: String) -> AnyPublisher<Void, Error> {
        api.request(
            target: UserTargets.InviteUser(id: id)
        )
    }

    func addReferral(referredByCode: String) -> AnyPublisher<Int, Error> {
        api.request(
            target: UserTargets.AddReferral(referredByCode: referredByCode),
            atKeyPath: "data.rewardPoints"
        )
    }
}
