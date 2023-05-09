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
    let seenByType: SeenByType?
    let backgroundColor: String

    init(currentUser: User,
         conversation: Conversation,
         message: Message,
         seenUsers: [User],
         backgroundColor: String) {
        self.message = message.message ?? ""
        self.createdAt = message.createdAt
        self.seenByType = {
            guard message.sender.id == currentUser.id else {
                return nil
            }
            switch conversation.type {
            case .single: return .single(!seenUsers.isEmpty)
            case .group: return .group(seenUsers.count)
            case .unknown: return .unknown
            }
        }()
        self.backgroundColor = backgroundColor
    }
}
