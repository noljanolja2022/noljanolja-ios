//
//  ChatMessage.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation
import UIKit

// MARK: - MessageItemModel.ContentType

extension NormalMessageModel {
    enum ContentType: Equatable {
        case plaintext(TextMessageContentModel)
        case photo(PhotoMessageContentModel)
        case sticker(StickerMessageContentModel)
    }

    struct PositionType: OptionSet {
        let rawValue: UInt8

        static let first = PositionType(rawValue: 1 << 0)
        static let middle = PositionType(rawValue: 1 << 1)
        static let last = PositionType(rawValue: 1 << 2)
    }

    enum StatusType: Equatable {
        case none
        case sending
        case sent
        case seen([User])
    }
}

// MARK: - NormalMessageModel

struct NormalMessageModel: Equatable {
    let isSendByCurrentUser: Bool
    let senderAvatar: String
    let senderName: String
    let content: ContentType
    let status: StatusType

    let senderAvatarVisibility: VisibilityType
    let senderNameVisibility: VisibilityType

    let topPadding: CGFloat

    init?(currentUser: User,
          conversation: Conversation,
          message: Message,
          positionType: PositionType,
          status: StatusType) {
        self.isSendByCurrentUser = currentUser.id == message.sender.id
        self.senderAvatar = message.sender.avatar ?? ""
        self.senderName = message.sender.name ?? ""

        let background: MessageContentBackgroundModel = {
            let backgroundColor = message.sender.id == currentUser.id
                ? ColorAssets.primaryGreen50.name
                : ColorAssets.neutralRawLightGrey.name
            let rotationAngle = message.sender.id == currentUser.id ? 0 : .pi

            if message.sender.id == currentUser.id || conversation.type == .single {
                if positionType.contains(.last) {
                    return MessageContentBackgroundModel(
                        type: .bubble(
                            MessageContentBackgroundModel.BubbleBackgroundModel()
                        ),
                        color: backgroundColor,
                        rotationAngle: rotationAngle
                    )
                } else {
                    return MessageContentBackgroundModel(
                        type: .cornerRadius(
                            MessageContentBackgroundModel.CornerRadiusBackgroundModel(
                            )
                        ),
                        color: backgroundColor,
                        rotationAngle: rotationAngle
                    )
                }
            } else {
                return MessageContentBackgroundModel(
                    type: .cornerRadius(
                        MessageContentBackgroundModel.CornerRadiusBackgroundModel(
                        )
                    ),
                    color: backgroundColor,
                    rotationAngle: rotationAngle
                )
            }
        }()
        switch message.type {
        case .plaintext:
            self.content = .plaintext(
                TextMessageContentModel(
                    currentUser: currentUser,
                    conversation: conversation,
                    message: message,
                    status: status,
                    background: background
                )
            )
        case .photo:
            self.content = .photo(
                PhotoMessageContentModel(
                    currentUser: currentUser,
                    message: message,
                    status: status,
                    background: background
                )
            )
        case .sticker:
            self.content = .sticker(
                StickerMessageContentModel(
                    currentUser: currentUser,
                    message: message,
                    status: status,
                    background: background
                )
            )
        case .eventUpdated, .eventJoined, .eventLeft, .unknown:
            return nil
        }
        self.status = status
        
        self.senderAvatarVisibility = {
            if message.sender.id == currentUser.id {
                switch conversation.type {
                case .group: return .invisible
                case .single, .unknown: return .gone
                }
            } else {
                switch conversation.type {
                case .group:
                    return positionType.contains(.first) ? .visible : .invisible
                case .single, .unknown:
                    return .gone
                }
            }
        }()
        self.senderNameVisibility = {
            guard message.sender.id != currentUser.id else {
                return .gone
            }
            switch conversation.type {
            case .group:
                return positionType.contains(.first) ? .visible : .gone
            case .single, .unknown:
                return .gone
            }
        }()
        self.topPadding = positionType.contains(.first) ? 16 : 4
    }
}
