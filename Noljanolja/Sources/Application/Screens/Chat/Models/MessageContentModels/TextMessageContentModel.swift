//
//  TextMessageContentModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import Foundation

// MARK: - TextMessageContentModel

struct TextMessageContentModel: Equatable, MessageContentModelType {
    let isSenderMessage: Bool
    let message: String?

    init(currentUser: User, message: Message) {
        self.isSenderMessage = currentUser.id == message.sender.id
        self.message = message.message
    }

    init(isSenderMessage: Bool, message: String?) {
        self.isSenderMessage = isSenderMessage
        self.message = message
    }
}
