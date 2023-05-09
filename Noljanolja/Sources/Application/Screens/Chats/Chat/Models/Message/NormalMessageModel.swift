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
    let isSendByCurrentUser: Bool
    let senderAvatar: String
    let senderName: String
    let content: ContentType
    let seenUsers: [User]
    let positionType: PositionType
    let status: StatusType

    let senderAvatarVisibility: VisibilityType
    let senderNameVisibility: VisibilityType

    init?(currentUser: User,
          conversation: Conversation,
          message: Message,
          seenUsers: [User],
          positionType: PositionType,
          status: StatusType) {
        self.isSendByCurrentUser = currentUser.id == message.sender.id
        self.senderAvatar = message.sender.avatar ?? ""
        self.senderName = message.sender.name ?? ""
        self.senderAvatarVisibility = {
            if message.sender.id == currentUser.id {
                switch conversation.type {
                case .group: return .invisible
                case .single, .unknown: return .gone
                }
            } else {
                switch conversation.type {
                case .group:
                    switch positionType {
                    case .all, .first: return .visible
                    case .middle, .last: return .invisible
                    }
                case .single, .unknown: return .gone
                }
            }
        }()
        self.senderNameVisibility = {
            guard message.sender.id != currentUser.id else {
                return .gone
            }
            switch conversation.type {
            case .group:
                switch positionType {
                case .all, .first: return .visible
                case .middle, .last: return .gone
                }
            case .single, .unknown: return .gone
            }
        }()

        let backgroundColor = {
            if message.sender.id == currentUser.id {
                return ColorAssets.primaryGreen50.name
            } else {
                return ColorAssets.neutralLightGrey.name
            }
        }()
        switch message.type {
        case .plaintext:
            self.content = .plaintext(
                TextMessageContentModel(
                    currentUser: currentUser,
                    conversation: conversation,
                    message: message,
                    seenUsers: seenUsers,
                    backgroundColor: backgroundColor
                )
            )
        case .photo:
            self.content = .photo(
                PhotoMessageContentModel(
                    currentUser: currentUser,
                    message: message,
                    seenUsers: seenUsers,
                    backgroundColor: backgroundColor
                )
            )
        case .sticker:
            self.content = .sticker(
                StickerMessageContentModel(
                    currentUser: currentUser,
                    message: message,
                    seenUsers: seenUsers
                )
            )
        case .eventUpdated, .eventJoined, .eventLeft, .unknown:
            return nil
        }
        self.seenUsers = seenUsers
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
