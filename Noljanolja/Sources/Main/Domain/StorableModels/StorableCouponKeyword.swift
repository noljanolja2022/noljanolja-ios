//
//  StorableCouponKeyword.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//

import Foundation
import RealmSwift

// MARK: - StorableUser

final class StorableCouponKeyword: Object {
    @Persisted(primaryKey: true) var keyword: String
    @Persisted var createdAt: Date?

    var model: CouponKeyword? {
        guard let createdAt else {
            return nil
        }
        return CouponKeyword(keyword: keyword, createdAt: createdAt)
    }

    required convenience init(_ model: CouponKeyword) {
        self.init()
        self.keyword = model.keyword
        self.createdAt = model.createdAt
    }

    override static func primaryKey() -> String? {
        "keyword"
    }
}
