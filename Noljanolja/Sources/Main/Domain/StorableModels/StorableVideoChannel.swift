//
//  StorableVideoChannel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/07/2023.
//

import Foundation
import RealmSwift

final class StorableVideoChannel: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String?
    @Persisted var thumbnail: String?

    var model: VideoChannel? {
        VideoChannel(id: id, title: title, thumbnail: thumbnail)
    }

    required convenience init(_ model: VideoChannel) {
        self.init()
        self.id = model.id
        self.title = model.title
        self.thumbnail = model.thumbnail
    }

    override static func primaryKey() -> String? {
        "id"
    }
}
