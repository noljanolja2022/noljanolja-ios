//
//  ConversationItemModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/03/2023.
//

import Foundation

struct ConversationItemModel: Equatable {
    let id: Int
    let image: String?
    let imagePlaceholder: String
    let title: String?
    let message: String?
    let date: String?
    let isSeen: Bool

    init(currentUser: User, conversation: Conversation) {
        self.id = conversation.id
        self.image = conversation.getAvatar(currentUser: currentUser)
        self.imagePlaceholder = {
            switch conversation.type {
            case .single: return ImageAssets.icChatPlaceholderSingle.name
            case .group: return ImageAssets.icChatPlaceholderGroup.name
            case .unknown: return ImageAssets.icChatPlaceholderGroup.name
            }
        }()
        self.message = {
            guard let lastMessage = conversation.messages.first else {
                let creatorName = conversation.creator.getDisplayName(currentUser: currentUser)
                return "\(creatorName) created conversation"
            }

            let subject = lastMessage.sender.getDisplayName(currentUser: currentUser)
            let verb = "sent"
            switch lastMessage.type {
            case .plaintext:
                return lastMessage.message
            case .photo:
                return [subject, verb, "photo"].joined(separator: " ")
            case .sticker:
                return [subject, verb, "sticker"].joined(separator: " ")
            case .eventUpdated, .eventJoined, .eventLeft:
                return "Conversation has changed"
            case .unknown:
                return ""
            }
        }()
        self.date = {
            let date = conversation.messages.first?.createdAt ?? conversation.updatedAt
            return date.relativeFormatForConversation()
        }()
        self.title = conversation.getDisplayTitleForItem(currentUser: currentUser)
        self.isSeen = {
            let lastReceiverMessage = conversation.messages.first(where: { $0.sender.id != currentUser.id })
            return lastReceiverMessage?.seenBy.contains(currentUser.id) ?? true
        }()
    }
}
