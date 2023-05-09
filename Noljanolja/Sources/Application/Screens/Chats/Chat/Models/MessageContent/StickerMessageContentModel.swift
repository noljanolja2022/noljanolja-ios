//
//  StickerMessageContentModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/03/2023.
//

import Foundation

// MARK: - TextMessageContentModel

struct StickerMessageContentModel: Equatable {
    let sticker: URL?
    let createdAt: Date
    let isSeen: Bool

    init(currentUser: User, message: Message, seenUsers: [User]) {
        self.sticker = message.getStickerURL()
        self.createdAt = message.createdAt
        self.isSeen = !seenUsers.isEmpty
    }
}
