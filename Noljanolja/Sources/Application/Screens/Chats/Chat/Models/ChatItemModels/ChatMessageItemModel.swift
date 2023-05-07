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
        case photo(PhotoMessageContentModel)
        case sticker(StickerMessageContentModel)
    }

    enum PositionType: Equatable {
        case all
        case first
        case middle
        case last
    }

    enum StatusType: Equatable {
        case none
        case sending
        case received
        case seen([User])
    }
}

// MARK: - ChatMessageItemModel

struct ChatMessageItemModel: Equatable {
    let isSenderMessage: Bool
    let avatar: String?
    let date: Date
    let content: ContentType
    let positionType: PositionType
    let status: StatusType

    init?(currentUser: User,
          message: Message,
          positionType: PositionType,
          status: StatusType) {
        self.isSenderMessage = currentUser.id == message.sender.id
        self.avatar = message.sender.avatar
        self.date = message.createdAt
        switch message.type {
        case .plaintext:
            self.content = .plaintext(
                TextMessageContentModel(
                    currentUser: currentUser,
                    message: message
                )
            )
        case .photo:
            self.content = .photo(
                PhotoMessageContentModel(
                    currentUser: currentUser,
                    message: message
                )
            )
        case .sticker:
            self.content = .sticker(
                StickerMessageContentModel(
                    currentUser: currentUser,
                    message: message
                )
            )
        case .eventUpdated, .eventJoined, .eventLeft, .unknown:
            return nil
        }
        self.positionType = positionType
        self.status = status
    }
}
