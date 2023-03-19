//
//  ConversationDetailService.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/03/2023.
//

import Combine
import Foundation

// MARK: - ConversationDetailServiceType

protocol ConversationDetailServiceType {
    func getConversation(conversationID: Int) -> AnyPublisher<Conversation, Error>
    func getLocalMessages(conversationID: Int) -> AnyPublisher<[Message], Error>
    func getMessages(conversationID: Int,
                     beforeMessageID: Int?,
                     afterMessageID: Int?) -> AnyPublisher<[Message], Error>
    func sendMessage(conversationID: Int,
                     message: String,
                     type: MessageType) -> AnyPublisher<Message, Error>
}

extension ConversationDetailServiceType {
    func getMessages(conversationID: Int,
                     beforeMessageID: Int? = nil,
                     afterMessageID: Int? = nil) -> AnyPublisher<[Message], Error> {
        getMessages(conversationID: conversationID, beforeMessageID: beforeMessageID, afterMessageID: afterMessageID)
    }
}

// MARK: - ConversationDetailService

final class ConversationDetailService: ConversationDetailServiceType {
    static let `default` = ConversationDetailService()

    private let conversationDetailAPI: ConversationDetailAPIType
    private let conversationStore: ConversationStoreType
    private let conversationDetailStore: ConversationDetailStoreType

    private init(conversationDetailAPI: ConversationDetailAPIType = ConversationDetailAPI.default,
                 conversationStore: ConversationStoreType = ConversationStore.default,
                 conversationDetailStore: ConversationDetailStoreType = ConversationDetailStore.default) {
        self.conversationDetailAPI = conversationDetailAPI
        self.conversationStore = conversationStore
        self.conversationDetailStore = conversationDetailStore
    }

    func getConversation(conversationID: Int) -> AnyPublisher<Conversation, Error> {
        let localConversation = conversationStore.observeConversation(conversationID: conversationID)
        let remoteConversation = conversationDetailAPI.getConversation(conversationID: conversationID)
        return Publishers.Merge(localConversation, remoteConversation)
            .eraseToAnyPublisher()
    }

    func getLocalMessages(conversationID: Int) -> AnyPublisher<[Message], Error> {
        conversationDetailStore
            .observeMessages(conversationID: conversationID)
            .map { $0.sorted { $0.createdAt > $1.createdAt } }
            .eraseToAnyPublisher()
    }

    func getMessages(conversationID: Int,
                     beforeMessageID: Int?,
                     afterMessageID: Int?) -> AnyPublisher<[Message], Error> {
        conversationDetailAPI
            .getMessages(
                conversationID: conversationID,
                beforeMessageID: beforeMessageID,
                afterMessageID: afterMessageID
            )
            .handleEvents(receiveOutput: { [weak self] in
                self?.conversationDetailStore.saveMessages($0)
            })
            .eraseToAnyPublisher()
    }

    func sendMessage(conversationID: Int,
                     message: String,
                     type: MessageType) -> AnyPublisher<Message, Error> {
        conversationDetailAPI
            .sendMessage(
                conversationID: conversationID,
                message: message,
                type: type
            )
            .handleEvents(receiveOutput: { [weak self] in
                self?.conversationDetailStore.saveMessages([$0])
            })
            .eraseToAnyPublisher()
    }
}
