//
//  StickerMessageContentModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/03/2023.
//

import Foundation
import SwiftUI

// MARK: - StickerMessageContentModel.ActionType

extension StickerMessageContentModel {
    enum ActionType {
        case reaction(ReactIcon)
        case openMessageQuickReactionDetail(GeometryProxy?)
        case openMessageActionDetail(GeometryProxy?)
    }
}

// MARK: - StickerMessageContentModel

struct StickerMessageContentModel: Equatable {
    let sticker: URL?
    let createdAt: Date
    let status: MessageStatusModel.StatusType
    let isForward: Bool
    let background: MessageContentBackgroundModel

    init(currentUser: User,
         message: Message,
         status: NormalMessageModel.StatusType,
         background: MessageContentBackgroundModel) {
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
        self.isForward = message.shareMessage != nil
        self.background = background
    }
}
