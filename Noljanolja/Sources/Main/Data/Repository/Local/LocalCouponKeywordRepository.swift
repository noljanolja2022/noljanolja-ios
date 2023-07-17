//
//  LocalCouponKeywordRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//

import Combine
import Foundation
import RealmSwift

// MARK: - LocalCouponKeywordRepository

protocol LocalCouponKeywordRepository {
    func saveCouponKeyword(_ couponKeyword: CouponKeyword)
    func observeCouponKeywords(_ string: String) -> AnyPublisher<[CouponKeyword], Error>
    func delete(_ couponKeyword: CouponKeyword)
    func deleteAll()
}

// MARK: - LocalCouponKeywordRepositoryImpl

final class LocalCouponKeywordRepositoryImpl: LocalCouponKeywordRepository {
    static let `default` = LocalCouponKeywordRepositoryImpl()

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

    func saveCouponKeyword(_ couponKeyword: CouponKeyword) {
        let storableCouponKeyword = StorableCouponKeyword(couponKeyword)
        realmManager.add(storableCouponKeyword, update: .all)
    }

    func observeCouponKeywords(_ string: String) -> AnyPublisher<[CouponKeyword], Error> {
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
                                    return $0.keyword.contains(string)
                                }
                            }
                            .sorted { $0.createdAt > $1.createdAt }
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func delete(_ couponKeyword: CouponKeyword) {
        guard let couponKeyword = realmManager.object(ofType: StorableCouponKeyword.self, forPrimaryKey: couponKeyword.keyword) else {
            return
        }
        realmManager.delete(couponKeyword)
    }

    func deleteAll() {
        realmManager.deleteAll()
    }
}
