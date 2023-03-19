//
//  ConversationDetailAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/03/2023.
//

import Combine
import Foundation
import Moya

// MARK: - ConversationDetailAPITargets

enum ConversationDetailAPITargets {
    struct GetConversation: BaseAuthTargetType {
        var path: String { "v1/conversations/\(conversationID)" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }

        let conversationID: Int
    }

    struct GetMessages: BaseAuthTargetType {
        var path: String { "v1/conversations/\(conversationID)/messages" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        let conversationID: Int
        let beforeMessageID: Int?
        let afterMessageID: Int?

        var parameters: [String: Any] {
            [
                "beforeMessageId": beforeMessageID,
                "afterMessageId": afterMessageID
            ]
            .compactMapValues { $0 }
        }
    }

    struct SendMessage: BaseAuthTargetType {
        var path: String { "v1/conversations/\(conversationID)/messages" }
        let method: Moya.Method = .post
        var task: Task {
            let message = MultipartFormData(provider: .data(message.data(using: .utf8) ?? Data()), name: "message")
            let type = MultipartFormData(provider: .data(type.rawValue.data(using: .utf8) ?? Data()), name: "type")
            return .uploadMultipart([message, type])
        }

        let conversationID: Int
        let message: String
        let type: MessageType
    }
}

// MARK: - ConversationDetailAPIType

protocol ConversationDetailAPIType {
    func getConversation(conversationID: Int) -> AnyPublisher<Conversation, Error>
    func getMessages(conversationID: Int,
                     beforeMessageID: Int?,
                     afterMessageID: Int?) -> AnyPublisher<[Message], Error>
    func sendMessage(conversationID: Int,
                     message: String,
                     type: MessageType) -> AnyPublisher<Message, Error>
}

extension ConversationDetailAPIType {
    func getMessages(conversationID: Int,
                     beforeMessageID: Int? = nil,
                     afterMessageID: Int? = nil) -> AnyPublisher<[Message], Error> {
        getMessages(
            conversationID: conversationID,
            beforeMessageID: beforeMessageID,
            afterMessageID: afterMessageID
        )
    }
}

// MARK: - ConversationDetailAPI

final class ConversationDetailAPI: ConversationDetailAPIType {
    static let `default` = ConversationDetailAPI()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getConversation(conversationID: Int) -> AnyPublisher<Conversation, Error> {
        api.request(
            target: ConversationDetailAPITargets.GetConversation(conversationID: conversationID),
            atKeyPath: "data"
        )
    }

    func getMessages(conversationID: Int,
                     beforeMessageID: Int?,
                     afterMessageID: Int?) -> AnyPublisher<[Message], Error> {
        api.request(
            target: ConversationDetailAPITargets.GetMessages(
                conversationID: conversationID,
                beforeMessageID: beforeMessageID,
                afterMessageID: afterMessageID
            ),
            atKeyPath: "data"
        )
    }

    func sendMessage(conversationID: Int,
                     message: String,
                     type: MessageType) -> AnyPublisher<Message, Error> {
        api.request(
            target: ConversationDetailAPITargets.SendMessage(
                conversationID: conversationID,
                message: message,
                type: type
            ),
            atKeyPath: "data"
        )
    }
}
