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
    func saveMessageParams(_ params: [SendMessageParam])
    func observeMessages(conversationID: Int) -> AnyPublisher<[Message], Error>
    
    func savePhoto(conversationID: Int, fileName: String, data: Data) throws
    func getPhotoURL(conversationID: Int, fileName: String) -> URL?
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
        let storableMessages = messages.map { message in
            let storedMessage = realmManager
                .objects(StorableMessage.self) {
                    $0.id == message.id || $0.localID == message.localID
                }
                .first
            return StorableMessage(primaryKey: storedMessage?.primaryKey, model: message)
        }
        realmManager.add(storableMessages, update: .all)
    }

    func saveMessageParams(_ params: [SendMessageParam]) {
        let storableMessages = params.map { StorableMessage(param: $0) }
        realmManager.add(storableMessages, update: .all)
    }

    func observeMessages(conversationID: Int) -> AnyPublisher<[Message], Error> {
        realmManager.objects(StorableMessage.self)
            .where { $0.conversationID == conversationID }
            .collectionPublisher
            .map { messages -> [Message] in messages.compactMap { $0.model } }
            .eraseToAnyPublisher()
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
