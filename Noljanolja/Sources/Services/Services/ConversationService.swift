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
    func getConversations() -> AnyPublisher<[Conversation], Error>
    func createConversation(title: String,
                            type: ConversationType,
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

    func getConversations() -> AnyPublisher<[Conversation], Error> {
        let localConversations = conversationStore
            .observeConversations()
            .filter { !$0.isEmpty }
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
                    .sorted { $0.updatedAt > $1.updatedAt }
            }

        let remoteConversations = conversationAPI
            .getConversations()
            .handleEvents(receiveOutput: { [weak self] in
                self?.conversationStore.saveConversations($0)
            })

        return Publishers.Merge(localConversations, remoteConversations)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func createConversation(title: String,
                            type: ConversationType,
                            participants: [User]) -> AnyPublisher<Conversation, Error> {
        conversationAPI.createConversation(title: title, type: type, participants: participants)
    }
}
