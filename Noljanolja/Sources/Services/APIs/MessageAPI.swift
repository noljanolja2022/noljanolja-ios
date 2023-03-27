//
//  MessageAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/03/2023.
//

import Combine
import Foundation
import Moya
import UIKit

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
            var multipartFormDatas = [MultipartFormData?]()

            if let data = type.rawValue.data(using: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(data), name: "type"))
            }

            if let data = message?.data(using: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(data), name: "message"))
            }

            attachments?.forEach { attachment in
                if let data = attachment.data {
                    multipartFormDatas.append(
                        MultipartFormData(provider: .data(data), name: "attachments", fileName: "\(attachment.name).jpeg", mimeType: "image/jpeg")
                    )
                }
            }

            return .uploadMultipart(multipartFormDatas.compactMap { $0 })
        }

        let conversationID: Int
        let type: MessageType
        let message: String?
        let attachments: [AttachmentParam]?
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
                     type: MessageType,
                     message: String?,
                     attachments: [AttachmentParam]?) -> AnyPublisher<Message, Error>
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
                     type: MessageType,
                     message: String?,
                     attachments: [AttachmentParam]?) -> AnyPublisher<Message, Error> {
        api.request(
            target: MessageAPITargets.SendMessage(
                conversationID: conversationID,
                type: type,
                message: message,
                attachments: attachments
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
