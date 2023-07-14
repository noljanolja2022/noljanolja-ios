//
//  PreviewReplyMessageModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/07/2023.
//

import Foundation

struct PreviewReplyMessageModel: Equatable {
    let imageURL: URL?
    let senderName: String?
    let message: String?

    init(_ message: Message) {
        self.senderName = message.sender.name
        switch message.type {
        case .plaintext:
            self.imageURL = nil
            self.message = message.message
        case .photo:
            self.imageURL = message.attachments
                .compactMap { $0.getPhotoURL(conversationID: message.conversationID) }
                .first
            self.message = "[Photo]"
        case .sticker:
            self.imageURL = message.getStickerURL()
            self.message = "[Sticker]"
        case .eventUpdated, .eventJoined, .eventLeft, .unknown:
            self.imageURL = nil
            self.message = nil
        }
    }
}
