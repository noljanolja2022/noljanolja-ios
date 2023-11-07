//
//  ShareMessageRequest.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/07/2023.
//

import Foundation

struct ShareMessageRequest {
    let type: MessageType
    let message: String?
    let attachments: AttachmentsRequest?
    let sticker: (StickerPack, Sticker)?
    let shareMessage: Message?
    let replyToMessage: Message?
    let shareVideo: Video?

    init(type: MessageType,
         message: String? = nil,
         attachments: AttachmentsRequest? = nil,
         sticker: (StickerPack, Sticker)? = nil,
         shareMessage: Message? = nil,
         replyToMessage: Message? = nil,
         shareVideo: Video? = nil) {
        self.type = type
        self.message = message
        self.attachments = attachments
        self.sticker = sticker
        self.shareMessage = shareMessage
        self.replyToMessage = replyToMessage
        self.shareVideo = shareVideo
    }
}
