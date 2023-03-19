//
//  MessageStore.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/03/2023.
//

import Combine
import Foundation
import RealmSwift

// MARK: - MessageStoreType

protocol MessageStoreType {
    func saveMessages(_ messages: [Message])
    func observeMessages(conversationID: Int) -> AnyPublisher<[Message], Error>
}

// MARK: - MessageStore

final class MessageStore: MessageStoreType {
    static let `default` = MessageStore()

    private lazy var realmManager: RealmManagerType = RealmManager(
        configuration: {
            var config = Realm.Configuration.defaultConfiguration
            config.fileURL!.deleteLastPathComponent()
            config.fileURL!.appendPathComponent("conversation_detail")
            config.fileURL!.appendPathExtension("realm")
            return config
        }(),
        queue: DispatchQueue(label: "realm.conversation_detail", qos: .default)
    )

    private init() {}

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
