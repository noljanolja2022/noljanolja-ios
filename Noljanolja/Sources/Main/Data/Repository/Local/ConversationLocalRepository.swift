//
//  ConversationLocalRepositoryImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Combine
import Foundation
import RealmSwift

// MARK: - ConversationLocalRepository

protocol ConversationLocalRepository {
    func saveConversations(_ conversations: [Conversation])

    func getConversations(type: ConversationType, participants: [User]) -> [Conversation]
    func observeConversations() -> AnyPublisher<[Conversation], Error>

    func removeConversation(conversationID: Int)
    func removeConversation(notIn conversations: [Conversation])

    func deleteAll()
}

// MARK: - ConversationLocalRepositoryImpl

final class ConversationLocalRepositoryImpl: ConversationLocalRepository {
    static let `default` = ConversationLocalRepositoryImpl()

    private lazy var realmManager: RealmManagerType = {
        let id = "conversation"
        return RealmManager(
            configuration: {
                var config = Realm.Configuration.defaultConfiguration
                config.schemaVersion = 2
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
        Just(())
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main) // TODO: Can only add notification blocks from within runloops
            .flatMapLatest { [weak self] _ -> AnyPublisher<[Conversation], Error> in
                guard let self else {
                    return Empty<[Conversation], Error>().eraseToAnyPublisher()
                }
                return self.realmManager.objects(StorableConversation.self)
                    .collectionPublisher
                    .map { conversations -> [Conversation] in conversations.compactMap { $0.model } }
                    .eraseToAnyPublisher()
            }
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

    func deleteAll() {
        realmManager.deleteAll()
    }
}
