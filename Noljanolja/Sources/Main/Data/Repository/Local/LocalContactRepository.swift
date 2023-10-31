//
//  LocalContactRepositoryImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/03/2023.
//

import Combine
import Foundation
import RealmSwift

// MARK: - LocalContactRepository

protocol LocalContactRepository {
    func saveContact(_ users: [User])
    func observeContacts() -> AnyPublisher<[User], Error>
    func deleteAll()
}

// MARK: - LocalContactRepositoryImpl

final class LocalContactRepositoryImpl: LocalContactRepository {
    static let `default` = LocalContactRepositoryImpl()
    
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
        Just(())
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main) // TODO: Can only add notification blocks from within runloops
            .flatMapLatest { [weak self] _ -> AnyPublisher<[User], Error> in
                guard let self else {
                    return Empty<[User], Error>().eraseToAnyPublisher()
                }
                return self.realmManager.objects(StorableUser.self)
                    .collectionPublisher
                    .freeze()
                    .map { users -> [User] in users.compactMap { $0.model } }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func deleteAll() {
        realmManager.deleteAll()
    }
}
