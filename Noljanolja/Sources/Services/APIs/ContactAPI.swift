//
//  ContactAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/03/2023.
//

import Combine
import Foundation
import Moya

// MARK: - ContactAPITargets

private enum ContactAPITargets {
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

// MARK: - ContactAPIType

protocol ContactAPIType {
    func syncContacts(_ contacts: [Contact]) -> AnyPublisher<[User], Error>
}

// MARK: - ContactAPI

final class ContactAPI: ContactAPIType {
    static let `default` = ContactAPI()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func syncContacts(_ contacts: [Contact]) -> AnyPublisher<[User], Error> {
        api.request(
            target: ContactAPITargets.SyncContacts(contacts: contacts),
            atKeyPath: "data"
        )
    }
}
