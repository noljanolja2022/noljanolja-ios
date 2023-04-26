//
//  MessageStore.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/03/2023.
//

import Combine
import Foundation
import RealmSwift
import SwifterSwift

// MARK: - MessageStoreType

protocol MessageStoreType {
    func saveMessages(_ messages: [Message])
    func saveMessageParameters(_ parameters: [SendMessageParam])
    func observeMessages(conversationID: Int) -> AnyPublisher<[Message], Error>
    
    func savePhoto(conversationID: Int, fileName: String, data: Data) throws
    func getPhotoURL(conversationID: Int, fileName: String) -> URL?

    func deleteAll()
}

// MARK: - MessageStore

final class MessageStore: MessageStoreType {
    static let `default` = MessageStore()

    private lazy var realmManager: RealmManagerType = {
        let id = "messages"
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

    func saveMessages(_ messages: [Message]) {
        let storableMessages = messages.map { message in
            let storedMessage = realmManager
                .objects(StorableMessage.self) {
                    ($0.id != nil && $0.id == message.id)
                        || ($0.localID != nil && $0.localID != "" && $0.localID == message.localID)
                }
                .first
            return StorableMessage(primaryKey: storedMessage?.primaryKey, model: message)
        }
        realmManager.add(storableMessages, update: .all)
    }

    func saveMessageParameters(_ parameters: [SendMessageParam]) {
        let storableMessages = parameters.map { StorableMessage(param: $0) }
        realmManager.add(storableMessages, update: .all)
    }

    func observeMessages(conversationID: Int) -> AnyPublisher<[Message], Error> {
        realmManager.objects(StorableMessage.self)
            .where { $0.conversationID == conversationID }
            .collectionPublisher
            .map { messages -> [Message] in messages.compactMap { $0.model } }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func deleteAll() {
        realmManager.deleteAll()
    }

    func savePhoto(conversationID: Int, fileName: String, data: Data) throws {
        let photoURL = generatePhotoURL(conversationID: conversationID, fileName: fileName)
        try FileManager.default.createDirectory(at: photoURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        FileManager.default.createFile(atPath: photoURL.path, contents: data)
    }

    func getPhotoURL(conversationID: Int, fileName: String) -> URL? {
        let photoURL = generatePhotoURL(conversationID: conversationID, fileName: fileName)
        if FileManager.default.fileExists(atPath: photoURL.path) {
            return photoURL
        } else {
            return nil
        }
    }
}

extension MessageStore {
    private func generatePhotoURL(conversationID: Int, fileName: String) -> URL {
        let directories = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let directory = directories[0]
        return directory.appendingPathComponent("conversation/\(conversationID)/attachments/\(fileName)")
    }
}
