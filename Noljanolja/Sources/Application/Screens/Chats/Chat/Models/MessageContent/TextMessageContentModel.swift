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

    init(currentUser: User,
         conversation: Conversation,
         message: Message,
         seenByType: SeenByType?) {
        self.message = message.message ?? ""
        self.createdAt = message.createdAt
        self.seenByType = seenByType
    }
}
