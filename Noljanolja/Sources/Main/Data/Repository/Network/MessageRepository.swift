//
//  MessageRepositoryImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/03/2023.
//

import Combine
import Foundation
import Moya
import UIKit

// MARK: - MessageTargets

private enum MessageTargets {
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

            if let replyToMessageID = param.replyToMessage?.id,
               let data = String(replyToMessageID).data(using: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(data), name: "replyToMessageId"))
            }

            if let shareMessageId = param.shareMessage?.id,
               let data = String(shareMessageId).data(using: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(data), name: "shareMessageId"))
            }

            return .uploadMultipart(multipartFormDatas.compactMap { $0 })
        }

        let param: SendMessageParam
    }

    struct ShareMessage: BaseAuthTargetType {
        var path: String { "v1/conversations/messages" }
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

            if let replyToMessageID = param.replyToMessageID,
               let data = String(replyToMessageID).data(using: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(data), name: "replyToMessageId"))
            }

            if let shareMessageID = param.shareMessageID,
               let data = String(shareMessageID).data(using: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(data), name: "shareMessageId"))
            }

            if let shareVideoId = param.shareVideoID,
               let data = String(shareVideoId).data(using: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(data), name: "shareVideoId"))
            }

            param.conversationIDs.forEach {
                let conversationIDString = String($0)
                if let data = conversationIDString.data(using: .utf8) {
                    multipartFormDatas.append(
                        MultipartFormData(provider: .data(data), name: "conversationIds")
                    )
                }
            }

            return .uploadMultipart(multipartFormDatas.compactMap { $0 })
        }

        let param: ShareMessageParam
    }

    struct DeleteMessage: BaseAuthTargetType {
        var path: String { "v1/conversations/\(conversationID)/messages/\(messageID)" }
        let method: Moya.Method = .delete
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding(boolEncoding: .literal)) }

        let conversationID: Int
        let messageID: Int
        let removeForSelfOnly = false

        var parameters: [String: Any] {
            [
                "removeForSelfOnly": removeForSelfOnly
            ]
            .compactMapValues { $0 }
        }
    }

    struct SeenMessage: BaseAuthTargetType {
        var path: String { "v1/conversations/\(conversationID)/messages/\(messageID)/seen" }
        let method: Moya.Method = .post
        var task: Task { .requestPlain }

        let conversationID: Int
        let messageID: Int
    }

    struct ReactMessage: BaseAuthTargetType {
        var path: String { "v1/conversations/\(conversationID)/messages/\(messageID)/reactions/\(reactionId)" }
        let method: Moya.Method = .put
        var task: Task { .requestPlain }

        let conversationID: Int
        let messageID: Int
        let reactionId: Int
    }
}

// MARK: - MessageRepository

protocol MessageRepository {
    func getMessages(conversationID: Int,
                     beforeMessageID: Int?,
                     afterMessageID: Int?) -> AnyPublisher<[Message], Error>
    func sendMessage(param: SendMessageParam) -> AnyPublisher<Message, Error>
    func shareMessage(param: ShareMessageParam) -> AnyPublisher<[Message], Error>
    func deleteMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error>

    func seenMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error>

    func getPhotoURL(conversationId: Int, attachmentId: String) -> URL?

    func reactMessage(conversationID: Int, messageID: Int, reactionId: Int) -> AnyPublisher<Void, Error>
}

extension MessageRepository {
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

// MARK: - MessageRepositoryImpl

final class MessageRepositoryImpl: MessageRepository {
    static let `default` = MessageRepositoryImpl()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getMessages(conversationID: Int,
                     beforeMessageID: Int?,
                     afterMessageID: Int?) -> AnyPublisher<[Message], Error> {
        api.request(
            target: MessageTargets.GetMessages(
                conversationID: conversationID,
                beforeMessageID: beforeMessageID,
                afterMessageID: afterMessageID
            ),
            atKeyPath: "data"
        )
    }

    func sendMessage(param: SendMessageParam) -> AnyPublisher<Message, Error> {
        api.request(
            target: MessageTargets.SendMessage(param: param),
            atKeyPath: "data"
        )
    }

    func shareMessage(param: ShareMessageParam) -> AnyPublisher<[Message], Error> {
        api.request(
            target: MessageTargets.ShareMessage(param: param),
            atKeyPath: "data"
        )
    }

    func deleteMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error> {
        api.request(
            target: MessageTargets.DeleteMessage(conversationID: conversationID, messageID: messageID)
        )
    }

    func seenMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error> {
        api.request(
            target: MessageTargets.SeenMessage(conversationID: conversationID, messageID: messageID)
        )
    }

    func getPhotoURL(conversationId: Int, attachmentId: String) -> URL? {
        let string = NetworkConfigs.BaseUrl.baseUrl + "/v1/conversations/\(conversationId)/attachments/\(attachmentId)"
        return URL(string: string)
    }

    func reactMessage(conversationID: Int, messageID: Int, reactionId: Int) -> AnyPublisher<Void, Error> {
        api.request(
            target: MessageTargets.ReactMessage(
                conversationID: conversationID,
                messageID: messageID,
                reactionId: reactionId
            )
        )
    }
}
