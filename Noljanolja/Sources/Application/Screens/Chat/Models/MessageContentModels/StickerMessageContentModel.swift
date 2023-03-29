//
//  StickerMessageContentModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/03/2023.
//

import Foundation

// MARK: - TextMessageContentModel

struct StickerMessageContentModel: Equatable, MessageContentModelType {
    let isSenderMessage: Bool
    let sticker: URL?

    init(currentUser: User, message: Message) {
        self.isSenderMessage = currentUser.id == message.sender.id
        self.sticker = message.getStickerURL()
    }

    init(isSenderMessage: Bool, sticker: URL?) {
        self.isSenderMessage = isSenderMessage
        self.sticker = sticker
    }
}
