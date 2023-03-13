//
//  ChatMessage.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation
import UIKit

// MARK: - MessageItemModel.ContentType

extension ChatMessageItemModel {
    enum ContentType: Equatable {
        case plaintext(TextMessageContentModel)
    }

    enum PositionType {
        case all
        case first
        case middle
        case last
    }
}

// MARK: - ChatMessageItemModel

struct ChatMessageItemModel: Equatable {
    let id: Int
    let isSenderMessage: Bool
    let avatar: String?
    let date: Date
    let content: ContentType
    let positionType: PositionType

    init(id: Int,
         isSenderMessage: Bool,
         avatar: String?,
         date: Date,
         content: ContentType,
         positionType: PositionType = .middle) {
        self.id = id
        self.isSenderMessage = isSenderMessage
        self.avatar = avatar
        self.date = date
        self.content = content
        self.positionType = positionType
    }

    init(currentUser: User, message: Message, positionType: PositionType) {
        self.id = message.id
        self.isSenderMessage = currentUser.id == message.sender.id
        self.avatar = message.sender.avatar
        self.date = message.createdAt
        switch message.type {
        default:
            self.content = .plaintext(
                TextMessageContentModel(
                    currentUser: currentUser,
                    message: message
                )
            )
        }
        self.positionType = positionType
    }
}
