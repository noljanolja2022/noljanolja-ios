//
//  TextMessageContentModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import Foundation

// MARK: - TextMessageContentModel

struct TextMessageContentModel: Equatable {
    let message: String
    let createdAt: Date
    let status: MessageStatusModel.StatusType
    let backgroundColor: String

    init(currentUser: User,
         conversation: Conversation,
         message: Message,
         status: NormalMessageModel.StatusType,
         backgroundColor: String) {
        self.message = message.message ?? ""
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
        self.backgroundColor = backgroundColor
    }
}
