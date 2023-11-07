//
//  ConversationLocalRepositoryImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//

import Combine
import Foundation
import RealmSwift

// MARK: - DetailConversationLocalRepository

protocol DetailConversationLocalRepository {
    func saveConversationDetails(_ conversations: [Conversation])

    func getConversationDetail(id: Int) -> Conversation?
    func observeConversationDetail(conversationID: Int) -> AnyPublisher<Conversation, Error>

    func removeConversationDetail(conversationID: Int)

    func deleteAll()
}

// MARK: - DetailConversationLocalRepositoryImpl

final class DetailConversationLocalRepositoryImpl: DetailConversationLocalRepository {
    static let `default` = DetailConversationLocalRepositoryImpl()

    private lazy var realmManager: RealmManagerType = {
        let id = "conversation_detail"
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
        Just(())
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main) // TODO: Can only add notification blocks from within runloops
            .flatMapLatest { [weak self] _ -> AnyPublisher<Conversation, Error> in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.realmManager.objects(
                    StorableConversation.self,
                    isIncluded: { $0.id == conversationID }
                )
                .collectionPublisher
                .compactMap { conversations -> Conversation? in conversations.first.flatMap { $0.model } }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func removeConversationDetail(conversationID: Int) {
        guard let conversation = realmManager.object(ofType: StorableConversation.self, forPrimaryKey: conversationID) else {
            return
        }
        realmManager.delete(conversation)
    }

    func deleteAll() {
        realmManager.deleteAll()
    }
}
