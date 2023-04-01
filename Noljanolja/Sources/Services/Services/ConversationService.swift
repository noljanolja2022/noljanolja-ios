//
//  ConversationService.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Combine
import Foundation

// MARK: - ConversationServiceType

protocol ConversationServiceType {
    func getConversation(conversationID: Int) -> AnyPublisher<Conversation, Error>
    func getConversations() -> AnyPublisher<[Conversation], Error>
    func createConversation(type: ConversationType,
                            participants: [User]) -> AnyPublisher<Conversation, Error>
}

// MARK: - ConversationService

final class ConversationService: ConversationServiceType {
    static let `default` = ConversationService()

    private let conversationAPI: ConversationAPIType
    private let conversationStore: ConversationStoreType

    private init(conversationAPI: ConversationAPIType = ConversationAPI.default,
                 conversationStore: ConversationStoreType = ConversationStore.default) {
        self.conversationAPI = conversationAPI
        self.conversationStore = conversationStore
    }

    func getConversation(conversationID: Int) -> AnyPublisher<Conversation, Error> {
        let localConversation = conversationStore
            .observeConversation(conversationID: conversationID)
        let remoteConversation = conversationAPI
            .getConversation(conversationID: conversationID)
            .handleEvents(receiveOutput: { [weak self] in
                self?.conversationStore.saveConversations([$0])
            })
        return Publishers.Merge(localConversation, remoteConversation)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func getConversations() -> AnyPublisher<[Conversation], Error> {
        let localConversations = conversationStore
            .observeConversations()
            .filter { !$0.isEmpty }

        let remoteConversations = conversationAPI
            .getConversations()
            .handleEvents(receiveOutput: { [weak self] in
                self?.conversationStore.saveConversations($0)
            })

        return Publishers.Merge(localConversations, remoteConversations)
            .map {
                $0
                    .map {
                        Conversation(
                            id: $0.id,
                            title: $0.title,
                            creator: $0.creator,
                            type: $0.type,
                            messages: $0.messages.sorted { $0.createdAt > $1.createdAt },
                            participants: $0.participants,
                            createdAt: $0.createdAt,
                            updatedAt: $0.updatedAt
                        )
                    }
                    .sorted { lhs, rhs in
                        let lhsLastMessage = lhs.messages.first
                        let rhsLastMessage = rhs.messages.first
                        if let lhsLastMessage, let rhsLastMessage {
                            return lhsLastMessage.createdAt > rhsLastMessage.createdAt
                        } else if lhsLastMessage != nil {
                            return true
                        } else if rhsLastMessage != nil {
                            return false
                        } else {
                            return false
                        }
                    }
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func createConversation(type: ConversationType,
                            participants: [User]) -> AnyPublisher<Conversation, Error> {
        conversationAPI.createConversation(title: "", type: type, participants: participants)
    }
}
