//
//  StorableVideoKeyword.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/07/2023.
//

import Foundation
import RealmSwift

// MARK: - StorableUser

final class StorableVideoKeyword: Object {
    @Persisted(primaryKey: true) var keyword: String
    @Persisted var createdAt: Date?

    var model: VideoKeyword? {
        guard let createdAt else {
            return nil
        }
        return VideoKeyword(keyword: keyword, createdAt: createdAt)
    }

    required convenience init(_ model: VideoKeyword) {
        self.init()
        self.keyword = model.keyword
        self.createdAt = model.createdAt
    }

    override static func primaryKey() -> String? {
        "keyword"
    }
}
