//
//  ConversationAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Combine
import Foundation
import Moya

// MARK: - ConversationAPITargets

enum ConversationAPITargets {
    struct GetConversations: BaseAuthTargetType {
        var path: String { "v1/conversations" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }
    }

    struct CreateConversation: BaseAuthTargetType {
        var path: String { "v1/conversations" }
        let method: Moya.Method = .post
        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }

        let title: String
        let type: ConversationType
        let participants: [User]

        var parameters: [String: Any] {
            [
                "title": title,
                "type": type.rawValue,
                "participantIds": participants.map { $0.id }
            ]
        }
    }
}

// MARK: - ConversationAPIType

protocol ConversationAPIType {
    func getConversations() -> AnyPublisher<[Conversation], Error>
    func createConversation(title: String,
                            type: ConversationType,
                            participants: [User]) -> AnyPublisher<Conversation, Error>
}

// MARK: - ConversationAPI

final class ConversationAPI: ConversationAPIType {
    static let `default` = ConversationAPI()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getConversations() -> AnyPublisher<[Conversation], Error> {
        api.request(
            target: ConversationAPITargets.GetConversations(),
            atKeyPath: "data"
        )
    }

    func createConversation(title: String,
                            type: ConversationType,
                            participants: [User]) -> AnyPublisher<Conversation, Error> {
        api.request(
            target: ConversationAPITargets.CreateConversation(title: title, type: type, participants: participants),
            atKeyPath: "data"
        )
    }
}
