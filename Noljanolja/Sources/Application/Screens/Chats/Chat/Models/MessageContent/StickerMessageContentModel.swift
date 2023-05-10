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
    let status: MessageStatusModel.StatusType

    init(currentUser: User,
         message: Message,
         status: NormalMessageModel.StatusType) {
        self.sticker = message.getStickerURL()
        self.createdAt = message.createdAt
        self.status = {
            guard message.sender.id == currentUser.id else {
                return .none
            }
            switch status {
            case .none, .sending, .sent: return .none
            case let .seen(users): return .seen(.single(!users.isEmpty))
            }
        }()
    }
}
