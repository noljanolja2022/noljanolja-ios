//
//  ConversationDetailStore.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/03/2023.
//

import Combine
import Foundation
import RealmSwift

// MARK: - ConversationDetailStoreType

protocol ConversationDetailStoreType {
    func saveMessages(_ messages: [Message])
    func observeMessages(conversationID: Int) -> AnyPublisher<[Message], Error>
}

// MARK: - ConversationDetailStore

final class ConversationDetailStore: ConversationDetailStoreType {
    static let `default` = ConversationDetailStore()

    private let realm: Realm

    private init(realm: Realm = Realm.default) {
        self.realm = realm
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
