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

    private let realm: Realm

    private init(realm: Realm = Realm.default) {
        self.realm = realm
    }

    func saveConversations(_ conversations: [Conversation]) {
        try? realm.write {
            let storableConversations = conversations.map { StorableConversation($0) }
            realm.add(storableConversations, update: .modified)
        }
    }

    func observeConversations() -> AnyPublisher<[Conversation], Error> {
        realm.objects(StorableConversation.self)
            .collectionPublisher
            .map { conversations -> [Conversation] in conversations.compactMap { $0.model } }
            .eraseToAnyPublisher()
    }

    func saveMessages(_ messages: [Message]) {
        try? realm.write {
            let storableMessages = messages.map { StorableMessage($0) }
            realm.add(storableMessages, update: .modified)
        }
    }

    func observeMessages(conversationID: Int) -> AnyPublisher<[Message], Error> {
        realm.objects(StorableMessage.self)
            .where { $0.conversationID == conversationID }
            .collectionPublisher
            .map { messages -> [Message] in messages.compactMap { $0.model } }
            .eraseToAnyPublisher()
    }
}
