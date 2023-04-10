//
//  ConversationDetailStore.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//

import Combine
import Foundation
import RealmSwift

// MARK: - ConversationDetailStoreType

protocol ConversationDetailStoreType {
    func saveConversationDetails(_ conversations: [Conversation])

    func getConversationDetail(id: Int) -> Conversation?
    func observeConversationDetail(conversationID: Int) -> AnyPublisher<Conversation, Error>

    func removeConversationDetail(conversationID: Int)
}

// MARK: - ConversationDetailStore

final class ConversationDetailStore: ConversationDetailStoreType {
    static let `default` = ConversationDetailStore()

    private lazy var realmManager: RealmManagerType = {
        let id = "conversation_detail"
        return RealmManager(
            configuration: {
                var config = Realm.Configuration.defaultConfiguration
                config.fileURL!.deleteLastPathComponent()
                config.fileURL!.appendPathComponent(id)
                config.fileURL!.appendPathExtension("realm")
                return config
            }(),
            queue: DispatchQueue(label: "realm.\(id)", qos: .default)
        )
    }()

    private init() {}

    func saveConversationDetails(_ conversations: [Conversation]) {
        let storableConversations = conversations
            .map { StorableConversation($0) }
        realmManager.add(storableConversations, update: .all)
    }

    func getConversationDetail(id: Int) -> Conversation? {
        let savedConversation = realmManager
            .object(ofType: StorableConversation.self, forPrimaryKey: id)
        return savedConversation?.model
    }

    func observeConversationDetail(conversationID: Int) -> AnyPublisher<Conversation, Error> {
        realmManager.objects(StorableConversation.self) { $0.id == conversationID }
            .collectionPublisher
            .compactMap { conversations -> Conversation? in conversations.first.flatMap { $0.model } }
            .eraseToAnyPublisher()
    }

    func removeConversationDetail(conversationID: Int) {
        guard let conversation = realmManager.object(ofType: StorableConversation.self, forPrimaryKey: conversationID) else {
            return
        }
        realmManager.delete(conversation)
    }
}
