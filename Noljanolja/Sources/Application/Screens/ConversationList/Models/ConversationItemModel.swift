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
    let title: String?
    let lastMessage: Message?
    let date: String?
    let isSeen: Bool

    init(currentUser: User, conversation: Conversation) {
        self.id = conversation.id
        self.image = conversation.getAvatar(currentUser: currentUser)
        self.lastMessage = conversation.messages.first
        self.date = conversation.messages.first?.createdAt.relativeFormatForConversation()
        self.title = conversation.getDisplayTitleForItem(currentUser: currentUser)
        self.isSeen = {
            let lastReceiverMessage = conversation.messages.first(where: { $0.sender.id != currentUser.id })
            return lastReceiverMessage?.seenBy.contains(currentUser.id) ?? true
        }()
    }
}
