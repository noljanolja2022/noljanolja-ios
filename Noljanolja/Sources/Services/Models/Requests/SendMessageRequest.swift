//
//  File.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/03/2023.
//

import Foundation

struct SendMessageRequest {
    let conversationID: Int
    let type: MessageType
    let message: String?
    let photos: [PhotoAsset]?
    let sticker: (StickerPack, Sticker)?

    init(conversationID: Int,
         type: MessageType,
         message: String? = nil,
         photos: [PhotoAsset]? = nil,
         sticker: (StickerPack, Sticker)? = nil) {
        self.conversationID = conversationID
        self.type = type
        self.message = message
        self.photos = photos
        self.sticker = sticker
    }
}
