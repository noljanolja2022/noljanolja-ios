//
//  MessageService.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/03/2023.
//

import Combine
import Foundation

// MARK: - MessageServiceType

protocol MessageServiceType {
    func getLocalMessages(conversationID: Int) -> AnyPublisher<[Message], Error>
    func getMessages(conversationID: Int,
                     beforeMessageID: Int?,
                     afterMessageID: Int?) -> AnyPublisher<[Message], Error>
    func sendMessage(conversationID: Int,
                     message: String,
                     type: MessageType) -> AnyPublisher<Message, Error>
    func seenMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error>
}

extension MessageServiceType {
    func getMessages(conversationID: Int,
                     beforeMessageID: Int? = nil,
                     afterMessageID: Int? = nil) -> AnyPublisher<[Message], Error> {
        getMessages(conversationID: conversationID, beforeMessageID: beforeMessageID, afterMessageID: afterMessageID)
    }
}

// MARK: - MessageService

final class MessageService: MessageServiceType {
    static let `default` = MessageService()

    private let messageAPI: MessageAPIType
    private let messageStore: MessageStoreType

    private init(messageAPI: MessageAPIType = MessageAPI.default,
                 conversationStore: ConversationStoreType = ConversationStore.default,
                 messageStore: MessageStoreType = MessageStore.default) {
        self.messageAPI = messageAPI
        self.messageStore = messageStore
    }

    func getLocalMessages(conversationID: Int) -> AnyPublisher<[Message], Error> {
        messageStore
            .observeMessages(conversationID: conversationID)
            .map { $0.sorted { $0.createdAt > $1.createdAt } }
            .eraseToAnyPublisher()
    }

    func getMessages(conversationID: Int,
                     beforeMessageID: Int?,
                     afterMessageID: Int?) -> AnyPublisher<[Message], Error> {
        messageAPI
            .getMessages(
                conversationID: conversationID,
                beforeMessageID: beforeMessageID,
                afterMessageID: afterMessageID
            )
            .handleEvents(receiveOutput: { [weak self] in
                self?.messageStore.saveMessages($0)
            })
            .eraseToAnyPublisher()
    }

    func sendMessage(conversationID: Int,
                     message: String,
                     type: MessageType) -> AnyPublisher<Message, Error> {
        messageAPI
            .sendMessage(
                conversationID: conversationID,
                message: message,
                type: type
            )
            .handleEvents(receiveOutput: { [weak self] in
                self?.messageStore.saveMessages([$0])
            })
            .eraseToAnyPublisher()
    }

    func seenMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error> {
        messageAPI
            .seenMessage(conversationID: conversationID, messageID: messageID)
    }
}
