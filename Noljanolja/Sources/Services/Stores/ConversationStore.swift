//
//  ConversationStore.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Combine
import Foundation
import RealmSwift

// MARK: - ConversationStoreType

protocol ConversationStoreType {
    func saveConversations(_ conversations: [Conversation])
    func observeConversations() -> AnyPublisher<[Conversation], Error>

    func saveMessages(_ messages: [Message])
    func observeMessages(conversationID: Int) -> AnyPublisher<[Message], Error>
}

// MARK: - ConversationStore

final class ConversationStore: ConversationStoreType {
    static let `default` = ConversationStore()

    private lazy var realmManager: RealmManagerType = RealmManager(
        configuration: {
            var config = Realm.Configuration.defaultConfiguration
            config.fileURL!.deleteLastPathComponent()
            config.fileURL!.appendPathComponent("conversation")
            config.fileURL!.appendPathExtension("realm")
            return config
        }(),
        queue: DispatchQueue(label: "realm.conversation", qos: .default)
    )

    private init() {}

    func saveConversations(_ conversations: [Conversation]) {
        let storableConversations = conversations
            .map { StorableConversation($0) }
        realmManager.add(storableConversations, update: .all)
    }

    func observeConversations() -> AnyPublisher<[Conversation], Error> {
        realmManager.objects(StorableConversation.self)
            .collectionPublisher
            .map { conversations -> [Conversation] in conversations.compactMap { $0.model } }
            .eraseToAnyPublisher()
    }

    func saveMessages(_ messages: [Message]) {
        let storableMessages = messages.map { StorableMessage($0) }
        realmManager.add(storableMessages, update: .all)
    }

    func observeMessages(conversationID: Int) -> AnyPublisher<[Message], Error> {
        realmManager.objects(StorableMessage.self)
            .where { $0.conversationID == conversationID }
            .collectionPublisher
            .map { messages -> [Message] in messages.compactMap { $0.model } }
            .eraseToAnyPublisher()
    }
}
