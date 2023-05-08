//
//  ChatMessage.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation
import UIKit

// MARK: - NormalMessageModel

struct NormalMessageModel: Equatable {
    let isSenderMessage: Bool
    let avatar: String?
    let content: ContentType
    let seenByType: SeenByType?
    let positionType: PositionType
    let status: StatusType

    init?(currentUser: User,
          conversation: Conversation,
          message: Message,
          seenByUsers: [User],
          positionType: PositionType,
          status: StatusType) {
        self.isSenderMessage = currentUser.id == message.sender.id
        self.avatar = message.sender.avatar

        self.seenByType = {
            guard message.sender.id == currentUser.id else {
                return nil
            }
            switch conversation.type {
            case .single: return .single(!seenByUsers.isEmpty)
            case .group: return .group(seenByUsers.count)
            case .unknown: return .unknown
            }
        }()
        switch message.type {
        case .plaintext:
            self.content = .plaintext(
                TextMessageContentModel(
                    currentUser: currentUser,
                    conversation: conversation,
                    message: message,
                    seenByType: seenByType
                )
            )
        case .photo:
            self.content = .photo(
                PhotoMessageContentModel(
                    currentUser: currentUser,
                    message: message,
                    seenByType: seenByType
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

// MARK: - MessageItemModel.ContentType

extension NormalMessageModel {
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
