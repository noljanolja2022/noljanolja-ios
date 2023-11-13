//
//  StorableGiftKeyword.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//

import Foundation
import RealmSwift

// MARK: - StorableGiftKeyword

final class StorableGiftKeyword: Object {
    @Persisted(primaryKey: true) var keyword: String
    @Persisted var createdAt: Date?

    var model: GiftKeyword? {
        guard let createdAt else {
            return nil
        }
        return GiftKeyword(keyword: keyword, createdAt: createdAt)
    }

    required convenience init(_ model: GiftKeyword) {
        self.init()
        self.keyword = model.keyword
        self.createdAt = model.createdAt
    }

    override static func primaryKey() -> String? {
        "keyword"
    }
}
