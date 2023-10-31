//
//  CouponKeywordLocalRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//

import Combine
import Foundation
import RealmSwift

// MARK: - CouponKeywordLocalRepository

protocol CouponKeywordLocalRepository {
    func saveKeyword(_ keyword: CouponKeyword)
    func observeKeywords(_ string: String) -> AnyPublisher<[CouponKeyword], Error>
    func delete(_ keyword: CouponKeyword)
    func deleteAll()
}

// MARK: - CouponKeywordLocalRepositoryImpl

final class CouponKeywordLocalRepositoryImpl: CouponKeywordLocalRepository {
    static let shared = CouponKeywordLocalRepositoryImpl()

    private lazy var realmManager: RealmManagerType = {
        let id = "coupon_keyword"
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

    func saveKeyword(_ keyword: CouponKeyword) {
        let storableKeyword = StorableCouponKeyword(keyword)
        realmManager.add(storableKeyword, update: .all)
    }

    func observeKeywords(_ string: String) -> AnyPublisher<[CouponKeyword], Error> {
        Just(())
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main) // TODO: Can only add notification blocks from within runloops
            .flatMapLatest { [weak self] _ -> AnyPublisher<[CouponKeyword], Error> in
                guard let self else {
                    return Empty<[CouponKeyword], Error>().eraseToAnyPublisher()
                }
                return self.realmManager.objects(StorableCouponKeyword.self)
                    .collectionPublisher
                    .map { keywords -> [CouponKeyword] in
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

    func delete(_ keyword: CouponKeyword) {
        guard let keyword = realmManager.object(ofType: StorableCouponKeyword.self, forPrimaryKey: keyword.keyword) else {
            return
        }
        realmManager.delete(keyword)
    }

    func deleteAll() {
        realmManager.deleteAll()
    }
}
