//
//  GiftKeywordLocalRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//

import Combine
import Foundation
import RealmSwift

// MARK: - GiftKeywordLocalRepository

protocol GiftKeywordLocalRepository {
    func saveKeyword(_ keyword: GiftKeyword)
    func observeKeywords(_ string: String) -> AnyPublisher<[GiftKeyword], Error>
    func delete(_ keyword: GiftKeyword)
    func deleteAll()
}

// MARK: - GiftKeywordLocalRepositoryImpl

final class GiftKeywordLocalRepositoryImpl: GiftKeywordLocalRepository {
    static let shared = GiftKeywordLocalRepositoryImpl()

    private lazy var realmManager: RealmManagerType = {
        let id = "gift_keyword"
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

    func saveKeyword(_ keyword: GiftKeyword) {
        let storableKeyword = StorableGiftKeyword(keyword)
        realmManager.add(storableKeyword, update: .all)
    }

    func observeKeywords(_ string: String) -> AnyPublisher<[GiftKeyword], Error> {
        Just(())
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main) // TODO: Can only add notification blocks from within runloops
            .flatMapLatest { [weak self] _ -> AnyPublisher<[GiftKeyword], Error> in
                guard let self else {
                    return Empty<[GiftKeyword], Error>().eraseToAnyPublisher()
                }
                return self.realmManager.objects(StorableGiftKeyword.self)
                    .collectionPublisher
                    .map { keywords -> [GiftKeyword] in
                        keywords
                            .compactMap { $0.model }
                            .filter {
                                if string.isEmpty {
                                    return true
                                } else {
                                    return $0.keyword.lowercased().contains(string.lowercased())
                                }
                            }
                            .sorted { $0.createdAt > $1.createdAt }
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func delete(_ keyword: GiftKeyword) {
        guard let keyword = realmManager.object(ofType: StorableGiftKeyword.self, forPrimaryKey: keyword.keyword) else {
            return
        }
        realmManager.delete(keyword)
    }

    func deleteAll() {
        realmManager.deleteAll()
    }
}
