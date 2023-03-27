//
//  File.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/03/2023.
//

import Foundation

struct SendMessageParam {
    let type: MessageType
    let message: String?
    let photos: [PhotoAsset]?
    let sticker: (StickerPack, Sticker)?

    init(type: MessageType,
         message: String? = nil,
         photos: [PhotoAsset]? = nil,
         sticker: (StickerPack, Sticker)? = nil) {
        self.type = type
        self.message = message
        self.photos = photos
        self.sticker = sticker
    }
}
