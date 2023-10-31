//
//  ConversationNetworkRepositoryImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Combine
import Foundation
import Moya

// MARK: - ConversationTargets

private enum ConversationTargets {
    struct CreateConversation: BaseAuthTargetType {
        var path: String { "v1/conversations" }
        let method: Moya.Method = .post

        var task: Task {
            var multipartFormDatas = [MultipartFormData?]()

            if let data = title.data(using: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(data), name: "title"))
            }

            participants.forEach { user in
                if let data = user.id.data(using: .utf8) {
                    multipartFormDatas.append(
                        MultipartFormData(provider: .data(data), name: "participantIds")
                    )
                }
            }

            if let data = type.rawValue.data(using: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(data), name: "type"))
            }

            return .uploadMultipart(multipartFormDatas.compactMap { $0 })
        }

        let title: String
        let type: ConversationType
        let participants: [User]
    }

    struct GetConversations: BaseAuthTargetType {
        var path: String { "v1/conversations" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }
    }

    struct GetConversation: BaseAuthTargetType {
        var path: String { "v1/conversations/\(conversationID)" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }

        let conversationID: Int
    }

    struct UpdateConversation: BaseAuthTargetType {
        var path: String { "v1/conversations/\(conversationID)" }
        let method: Moya.Method = .put
        var task: Task { .uploadMultipart(multipartFormDatas) }

        let conversationID: Int
        let title: String?
        let participants: [User]?
        let image: Data?

        var multipartFormDatas: [MultipartFormData] {
            var multipartFormDatas = [MultipartFormData?]()

            if let data = title?.data(using: .utf8) {
                multipartFormDatas.append(MultipartFormData(provider: .data(data), name: "title"))
            }

            participants?.forEach { participant in
                if let data = participant.id.data(using: .utf8) {
                    multipartFormDatas.append(
                        MultipartFormData(provider: .data(data), name: "participantIds")
                    )
                }
            }

            if let data = image {
                multipartFormDatas.append(MultipartFormData(provider: .data(data), name: "image"))
            }

            return multipartFormDatas.compactMap { $0 }
        }
    }

    struct GetConversationAttachments: BaseAuthTargetType {
        var path: String { "/v1/conversations/\(conversationID)/attachments" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        var parameters: [String: Any] {
            [
                "attachmentTypes": types.map { $0.rawValue }.joined(separator: ","),
                "page": page,
                "pageSize": pageSize
            ]
        }

        let conversationID: Int
        let types: [ConversationAttachmentType]
        let page: Int
        let pageSize: Int
    }
}

// MARK: - ConversationNetworkRepository

protocol ConversationNetworkRepository {
    func createConversation(title: String,
                            type: ConversationType,
                            participants: [User]) -> AnyPublisher<Conversation, Error>

    func getConversation(conversationID: Int) -> AnyPublisher<Conversation, Error>
    func getConversations() -> AnyPublisher<[Conversation], Error>

    func updateConversation(conversationID: Int,
                            title: String?,
                            participants: [User]?,
                            image: Data?) -> AnyPublisher<Conversation, Error>

    func getConversationAttachments(conversationID: Int,
                                    types: [ConversationAttachmentType],
                                    page: Int,
                                    pageSize: Int) -> AnyPublisher<PaginationResponse<[ConversationAttachment]>, Error>
}

// MARK: - ConversationNetworkRepositoryImpl

final class ConversationNetworkRepositoryImpl: ConversationNetworkRepository {
    static let `default` = ConversationNetworkRepositoryImpl()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func createConversation(title: String,
                            type: ConversationType,
                            participants: [User]) -> AnyPublisher<Conversation, Error> {
        api.request(
            target: ConversationTargets.CreateConversation(title: title, type: type, participants: participants),
            atKeyPath: "data"
        )
    }

    func getConversations() -> AnyPublisher<[Conversation], Error> {
        api.request(
            target: ConversationTargets.GetConversations(),
            atKeyPath: "data"
        )
    }

    func getConversation(conversationID: Int) -> AnyPublisher<Conversation, Error> {
        api.request(
            target: ConversationTargets.GetConversation(conversationID: conversationID),
            atKeyPath: "data"
        )
    }

    func updateConversation(conversationID: Int,
                            title: String?,
                            participants: [User]?,
                            image: Data?) -> AnyPublisher<Conversation, Error> {
        api.request(
            target: ConversationTargets.UpdateConversation(
                conversationID: conversationID,
                title: title,
                participants:
                participants,
                image: image
            ),
            atKeyPath: "data"
        )
    }

    func getConversationAttachments(conversationID: Int,
                                    types: [ConversationAttachmentType],
                                    page: Int,
                                    pageSize: Int) -> AnyPublisher<PaginationResponse<[ConversationAttachment]>, Error> {
        api.request(
            target: ConversationTargets.GetConversationAttachments(
                conversationID: conversationID,
                types: types,
                page: page,
                pageSize: pageSize
            )
        )
    }
}
