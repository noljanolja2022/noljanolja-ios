//
//  LocalMessageReactionRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/06/2023.
//

import Combine
import Foundation
import RealmSwift

// MARK: - ReactionIconsLocalRepository

protocol ReactionIconsLocalRepository {
    func saveReactIcons(_ models: [ReactIcon])
    func observeReactIcons() -> AnyPublisher<[ReactIcon], Error>
}

// MARK: - ReactionIconsLocalRepositoryImpl

final class ReactionIconsLocalRepositoryImpl: ReactionIconsLocalRepository {
    static let `default` = ReactionIconsLocalRepositoryImpl()

    private lazy var realmManager: RealmManagerType = {
        let id = "react_icons"
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

    func saveReactIcons(_ models: [ReactIcon]) {
        let storableModels = models.map { StorableReactIcon($0) }
        realmManager.add(storableModels, update: .all)
    }

    func observeReactIcons() -> AnyPublisher<[ReactIcon], Error> {
        Just(())
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main) // TODO: Can only add notification blocks from within runloops
            .flatMapLatest { [weak self] _ -> AnyPublisher<[ReactIcon], Error> in
                guard let self else {
                    return Empty<[ReactIcon], Error>().eraseToAnyPublisher()
                }
                return self.realmManager.objects(StorableReactIcon.self)
                    .collectionPublisher
                    .map { $0.compactMap { $0.model } }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
