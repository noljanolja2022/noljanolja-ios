//
//  TextMessageContentModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import Foundation
import SwiftUI

// MARK: - TextMessageContentModel

struct TextMessageContentModel: Equatable {
    let message: Message
    
    let messageString: String
    let createdAt: Date
    let status: MessageStatusModel.StatusType
    let background: MessageContentBackgroundModel
    let reactionSummaryModel: MessageReactionSummaryModel?
    let horizontalAlignment: HorizontalAlignment

    init(currentUser: User,
         conversation: Conversation,
         message: Message,
         status: NormalMessageModel.StatusType,
         background: MessageContentBackgroundModel) {
        self.message = message
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
                    case .group: return .group(conversation.participants.count - 1 - users.count)
                    case .unknown: return .none
                    }
                }())
            }
        }()
        self.background = background
        self.reactionSummaryModel = MessageReactionSummaryModel(message.reactions)
        self.horizontalAlignment = message.sender.id == currentUser.id ? .trailing : .leading
    }
}