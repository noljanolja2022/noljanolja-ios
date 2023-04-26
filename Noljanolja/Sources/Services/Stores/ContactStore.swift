//
//  ContactStore.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/03/2023.
//

import Combine
import Foundation
import RealmSwift

// MARK: - ContactStoreType

protocol ContactStoreType {
    func saveContact(_ users: [User])
    func observeContacts() -> AnyPublisher<[User], Error>
    func deleteAll()
}

// MARK: - ContactStore

final class ContactStore: ContactStoreType {
    static let `default` = ContactStore()
    
    private lazy var realmManager: RealmManagerType = {
        let id = "contact"
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

    func saveContact(_ users: [User]) {
        let storableContacts = users.map { StorableUser($0) }
        realmManager.add(storableContacts, update: .modified)
    }

    func observeContacts() -> AnyPublisher<[User], Error> {
        realmManager.objects(StorableUser.self)
            .collectionPublisher
            .freeze()
            .map { users -> [User] in users.compactMap { $0.model } }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func deleteAll() {
        realmManager.deleteAll()
    }
}
