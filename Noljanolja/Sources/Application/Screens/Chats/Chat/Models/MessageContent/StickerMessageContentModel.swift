//
//  StickerMessageContentModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/03/2023.
//

import Foundation
import SwiftUI

// MARK: - TextMessageContentModel

struct StickerMessageContentModel: Equatable {
    let message: Message

    let sticker: URL?
    let createdAt: Date
    let status: MessageStatusModel.StatusType
    let background: MessageContentBackgroundModel
    let reactionSummaryModel: MessageReactionSummaryModel?
    let horizontalAlignment: HorizontalAlignment

    init(currentUser: User,
         message: Message,
         status: NormalMessageModel.StatusType,
         background: MessageContentBackgroundModel) {
        self.message = message

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
        self.background = background
        self.reactionSummaryModel = MessageReactionSummaryModel(message.reactions)
        self.horizontalAlignment = message.sender.id == currentUser.id ? .trailing : .leading
    }
}
