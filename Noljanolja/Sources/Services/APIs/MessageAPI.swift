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
        var path: String { "v1/conversations/\(param.conversationID)/messages" }
        let method: Moya.Method = .post
        var task: Task {
            var multipartFormDatas = [MultipartFormData?]()

            if let data = param.type.rawValue.data(using: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(data), name: "type"))
            }

            if let data = param.message?.data(using: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(data), name: "message"))
            }

            param.attachments?.forEach { attachment in
                if let data = attachment.data {
                    multipartFormDatas.append(
                        MultipartFormData(provider: .data(data), name: "attachments", fileName: attachment.name, mimeType: "image/jpeg")
                    )
                }
            }

            if let data = param.localID.data(using: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(data), name: "localId"))
            }

            return .uploadMultipart(multipartFormDatas.compactMap { $0 })
        }

        let param: SendMessageParam
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
    func sendMessage(param: SendMessageParam) -> AnyPublisher<Message, Error>
    func seenMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error>

    func getPhotoURL(conversationId: Int, attachmentId: String) -> URL?
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

    func sendMessage(param: SendMessageParam) -> AnyPublisher<Message, Error> {
        api.request(
            target: MessageAPITargets.SendMessage(param: param),
            atKeyPath: "data"
        )
    }

    func seenMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error> {
        api.request(
            target: MessageAPITargets.SeenMessage(conversationID: conversationID, messageID: messageID)
        )
    }

    func getPhotoURL(conversationId: Int, attachmentId: String) -> URL? {
        let string = NetworkConfigs.baseUrl + "/v1/conversations/\(conversationId)/attachments/\(attachmentId)"
        return URL(string: string)
    }
}
