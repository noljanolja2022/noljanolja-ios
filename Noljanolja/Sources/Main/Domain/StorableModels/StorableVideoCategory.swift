//
//  StorableVideoCategory.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/07/2023.
//

import Foundation
import RealmSwift

final class StorableVideoCategory: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String?

    var model: VideoCategory? {
        VideoCategory(id: id, title: title)
    }

    required convenience init(_ model: VideoCategory) {
        self.init()
        self.id = model.id
        self.title = model.title
    }

    override static func primaryKey() -> String? {
        "id"
    }
}
