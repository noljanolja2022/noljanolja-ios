//
//  MessageAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/03/2023.
//

import Combine
import Foundation
import Moya

// MARK: - MessageAPITargets

private enum MessageAPITargets {
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

    struct SeenMessage: BaseAuthTargetType {
        var path: String { "v1/conversations/\(conversationID)/messages/\(messageID)/seen" }
        let method: Moya.Method = .post
        var task: Task { .requestPlain }

        let conversationID: Int
        let messageID: Int
    }
}

// MARK: - MessageAPIType

protocol MessageAPIType {
    func getMessages(conversationID: Int,
                     beforeMessageID: Int?,
                     afterMessageID: Int?) -> AnyPublisher<[Message], Error>
    func sendMessage(conversationID: Int,
                     message: String,
                     type: MessageType) -> AnyPublisher<Message, Error>
    func seenMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error>
}

extension MessageAPIType {
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

// MARK: - MessageAPI

final class MessageAPI: MessageAPIType {
    static let `default` = MessageAPI()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getMessages(conversationID: Int,
                     beforeMessageID: Int?,
                     afterMessageID: Int?) -> AnyPublisher<[Message], Error> {
        api.request(
            target: MessageAPITargets.GetMessages(
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
            target: MessageAPITargets.SendMessage(
                conversationID: conversationID,
                message: message,
                type: type
            ),
            atKeyPath: "data"
        )
    }

    func seenMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error> {
        api.request(
            target: MessageAPITargets.SeenMessage(conversationID: conversationID, messageID: messageID)
        )
    }
}
