//
//  TextMessageContentModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import Foundation
import SwiftUI

// MARK: - TextMessageContentModel.ActionType

extension TextMessageContentModel {
    enum ActionType {
        case openURL(String)
        case reaction(ReactIcon)
        case openMessageQuickReactionDetail(GeometryProxy?)
        case openMessageActionDetail(GeometryProxy?)
    }
}

// MARK: - TextMessageContentModel

struct TextMessageContentModel: Equatable {
    let messageString: String
    let createdAt: Date
    let status: MessageStatusModel.StatusType
    let isForward: Bool
    let background: MessageContentBackgroundModel

    init(currentUser: User,
         conversation: Conversation,
         message: Message,
         status: NormalMessageModel.StatusType,
         background: MessageContentBackgroundModel) {
        self.messageString = message.message ?? ""
        self.createdAt = message.createdAt
        self.status = {
            guard message.sender.id == currentUser.id else {
                return .none
            }
            switch status {
            case .none:
                return .none
            case .sending:
                return .sending
            case .sent:
                return .sent
            case let .seen(users):
                return .seen({
                    switch conversation.type {
                    case .single: return .single(!users.isEmpty)
                    case .group: return .group(users.count)
                    case .unknown: return .none
                    }
                }())
            }
        }()
        self.isForward = message.shareMessage != nil
        self.background = background
    }
}
