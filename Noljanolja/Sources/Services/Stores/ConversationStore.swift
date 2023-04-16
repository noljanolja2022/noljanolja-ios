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

    func getConversations(type: ConversationType, participants: [User]) -> [Conversation]
    func observeConversations() -> AnyPublisher<[Conversation], Error>

    func removeConversation(conversationID: Int)
    func removeConversation(notIn conversations: [Conversation])
}

// MARK: - ConversationStore

final class ConversationStore: ConversationStoreType {
    static let `default` = ConversationStore()

    private lazy var realmManager: RealmManagerType = {
        let id = "conversation"
        return RealmManager(
            configuration: {
                var config = Realm.Configuration.defaultConfiguration
                config.fileURL?.deleteLastPathComponent()
                config.fileURL?.appendPathComponent(id)
                config.fileURL?.appendPathExtension("realm")
                return config
            }(),
            queue: DispatchQueue(label: "realm.\(id)", qos: .default)
        )
    }()

    private init() {}

    func saveConversations(_ conversations: [Conversation]) {
        let storableConversations = conversations
            .map { StorableConversation($0) }
        realmManager.add(storableConversations, update: .all)
    }

    func getConversations(type: ConversationType, participants: [User]) -> [Conversation] {
        realmManager.objects(StorableConversation.self)
            .compactMap { $0.model }
            .filter { conversation in
                let conversationParticipantIDs = Set(conversation.participants.map { $0.id })
                let participantIDs = Set(participants.map { $0.id })
                return conversation.type == type
                    && conversationParticipantIDs == participantIDs
            }
    }

    func observeConversations() -> AnyPublisher<[Conversation], Error> {
        realmManager.objects(StorableConversation.self)
            .collectionPublisher
            .map { conversations -> [Conversation] in conversations.compactMap { $0.model } }
            .eraseToAnyPublisher()
    }

    func removeConversation(conversationID: Int) {
        guard let conversation = realmManager.object(ofType: StorableConversation.self, forPrimaryKey: conversationID) else {
            return
        }
        realmManager.delete(conversation)
    }

    func removeConversation(notIn conversations: [Conversation]) {
        let objects = realmManager.objects(
            StorableConversation.self,
            isIncluded: { conversation in
                !conversation.id.in(conversations.map { $0.id })
            }
        )
        realmManager.delete(objects)
    }
}
