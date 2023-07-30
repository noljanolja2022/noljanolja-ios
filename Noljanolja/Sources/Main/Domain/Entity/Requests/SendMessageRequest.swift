//
//  File.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/03/2023.
//

import Foundation
import UIKit

// MARK: - SendMessageRequest

struct SendMessageRequest {
    let conversationID: Int
    let type: MessageType
    let message: String?
    let attachments: AttachmentsRequest?
    let sticker: (StickerPack, Sticker)?
    let shareMessage: Message?
    let replyToMessage: Message?

    init(conversationID: Int,
         type: MessageType,
         message: String? = nil,
         attachments: AttachmentsRequest? = nil,
         sticker: (StickerPack, Sticker)? = nil,
         shareMessage: Message? = nil,
         replyToMessage: Message? = nil) {
        self.conversationID = conversationID
        self.type = type
        self.message = message
        self.attachments = attachments
        self.sticker = sticker
        self.shareMessage = shareMessage
        self.replyToMessage = replyToMessage
    }
}
