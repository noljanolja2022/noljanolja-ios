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
    let unseenNumber: Int?

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
                return L10n.conversationCreate(creatorName)
            }

            guard lastMessage.shareVideo == nil else {
                if lastMessage.sender.id == currentUser.id {
                    return L10n.chatsMessageMyVideo
                } else {
                    return L10n.chatsMessageVideo
                }
            }

            switch lastMessage.type {
            case .plaintext:
                return lastMessage.message
            case .photo:
                if lastMessage.sender.id == currentUser.id {
                    return L10n.chatsMessageMyPhoto
                } else {
                    return L10n.chatsMessagePhoto
                }
            case .sticker:
                if lastMessage.sender.id == currentUser.id {
                    return L10n.chatsMessageMySticker
                } else {
                    return L10n.chatsMessageSticker
                }
            case .eventUpdated, .eventJoined, .eventLeft:
                return L10n.conversationHasChanged
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
        self.unseenNumber = conversation.messages.reduce(0) { partialResult, message in
            if message.sender.id != currentUser.id, !message.seenBy.contains(currentUser.id) {
                return partialResult + 1
            }
            return partialResult
        }
    }
}
