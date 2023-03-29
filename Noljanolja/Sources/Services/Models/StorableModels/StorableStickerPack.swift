//
//  StorableStickerPack.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/03/2023.
//

import Foundation
import RealmSwift

final class StorableStickerPack: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String?
    @Persisted var publisher: String?
    @Persisted var trayImageFile: String?
    @Persisted var isAnimated: Bool?
    @Persisted var stickers = List<StorableSticker>()

    var model: StickerPack? {
        StickerPack(
            id: id,
            name: name,
            publisher: publisher,
            trayImageFile: trayImageFile ?? "",
            isAnimated: isAnimated ?? false,
            stickers: stickers.compactMap { $0.model }
        )
    }

    required convenience init(_ model: StickerPack) {
        self.init()
        self.id = model.id
        self.name = model.name
        self.publisher = model.publisher
        self.trayImageFile = model.trayImageFile
        self.isAnimated = isAnimated
        self.stickers = {
            let list = List<StorableSticker>()
            list.append(objectsIn: model.stickers.map { StorableSticker($0) })
            return list
        }()
    }
}
