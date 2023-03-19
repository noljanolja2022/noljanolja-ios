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
    let lastMessage: String?
    let date: String?

    init(id: Int, image: String?, title: String?, lastMessage: String?, date: String) {
        self.id = id
        self.image = image
        self.title = title
        self.lastMessage = lastMessage
        self.date = date
    }

    init(currentUser: User, conversation: Conversation) {
        self.id = conversation.id
        self.image = conversation.avatar(currentUser)
        self.lastMessage = conversation.messages.first?.message
        self.date = conversation.messages.last?.createdAt.string(withFormat: "HH:mm")
        self.title = conversation.displayTitle(currentUser)
    }
}
