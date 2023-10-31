//
//  StorableVideoComment.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/07/2023.
//

import Foundation
import RealmSwift

final class StorableVideoComment: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var comment: String?
    @Persisted var commenter: StorableVideoCommenter?
    @Persisted var createdAt: Date?
    @Persisted var updatedAt: Date?

    var model: VideoComment? {
        VideoComment(
            id: id,
            comment: comment,
            commenter: commenter?.model,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    required convenience init(_ model: VideoComment) {
        self.init()
        self.id = model.id
        self.comment = model.comment
        self.commenter = model.commenter.flatMap { StorableVideoCommenter($0) }
        self.createdAt = model.createdAt
        self.updatedAt = model.updatedAt
    }

    override static func primaryKey() -> String? {
        "id"
    }
}
