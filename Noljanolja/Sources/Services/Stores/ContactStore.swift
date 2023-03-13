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
}

// MARK: - ContactStore

final class ContactStore: ContactStoreType {
    static let `default` = ContactStore()

    private let realm: Realm

    private init(realm: Realm = Realm.default) {
        self.realm = realm
    }

    func saveContact(_ users: [User]) {
        try? realm.write {
            let storableContacts = users.map { StorableUser($0) }
            realm.add(storableContacts, update: .modified)
        }
    }

    func observeContacts() -> AnyPublisher<[User], Error> {
        realm.objects(StorableUser.self)
            .collectionPublisher
            .freeze()
            .map { users -> [User] in users.compactMap { $0.model } }
            .eraseToAnyPublisher()
    }
}
