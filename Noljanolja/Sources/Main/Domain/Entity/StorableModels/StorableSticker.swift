//
//  StorableSticker.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/03/2023.
//

import Foundation
import RealmSwift

final class StorableSticker: Object {
    @Persisted(primaryKey: true) var imageFile: String
    @Persisted var emojis = List<String>()

    var model: Sticker? {
        Sticker(imageFile: imageFile, emojis: emojis.map { $0 })
    }

    required convenience init(_ model: Sticker) {
        self.init()
        self.imageFile = model.imageFile
        self.emojis = {
            let list = List<String>()
            list.append(objectsIn: model.emojis)
            return list
        }()
    }

    override static func primaryKey() -> String? {
        "imageFile"
    }
}
