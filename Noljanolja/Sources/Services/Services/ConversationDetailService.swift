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
    func getMessages(conversationID: Int,
                     beforeMessageID: String?,
                     afterMessageID: String?) -> AnyPublisher<[Message], Error>
    func sendMessage(conversationID: Int,
                     message: String,
                     type: MessageType) -> AnyPublisher<Message, Error>
}

extension ConversationDetailServiceType {
    func getMessages(conversationID: Int,
                     beforeMessageID: String? = nil,
                     afterMessageID: String? = nil) -> AnyPublisher<[Message], Error> {
        getMessages(conversationID: conversationID, beforeMessageID: beforeMessageID, afterMessageID: afterMessageID)
    }
}

// MARK: - ConversationDetailService

final class ConversationDetailService: ConversationDetailServiceType {
    static let `default` = ConversationDetailService()

    private let conversationDetailAPI: ConversationDetailAPIType
    private let conversationDetailStore: ConversationDetailStoreType

    private init(conversationDetailAPI: ConversationDetailAPIType = ConversationDetailAPI.default,
                 conversationDetailStore: ConversationDetailStoreType = ConversationDetailStore.default) {
        self.conversationDetailAPI = conversationDetailAPI
        self.conversationDetailStore = conversationDetailStore
    }

    func getMessages(conversationID: Int,
                     beforeMessageID: String?,
                     afterMessageID: String?) -> AnyPublisher<[Message], Error> {
        let remoteMessages = conversationDetailAPI
            .getMessages(
                conversationID: conversationID,
                beforeMessageID: beforeMessageID,
                afterMessageID: afterMessageID
            )
            .handleEvents(receiveOutput: { [weak self] in
                self?.conversationDetailStore.saveMessages($0)
            })

        return remoteMessages
            .eraseToAnyPublisher()

//        let localMessages = conversationDetailStore
//            .observeMessages(conversationID: conversationID)
//            .filter { !$0.isEmpty }
//            .map { $0.sorted { $0.createdAt > $1.createdAt } }
//
//        return Publishers.Merge(remoteMessages, localMessages)
//            .removeDuplicates()
//            .eraseToAnyPublisher()
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
