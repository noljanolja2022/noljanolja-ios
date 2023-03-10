//
//  ChatMessage.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation

// MARK: - MessageItemModel.ContentType

extension MessageItemModel {
    enum ContentType: Equatable {
        case plaintext(PlaintextMessageContentItemModel)
    }
}

// MARK: - MessageItemModel

struct MessageItemModel: Equatable {
    let id: Int
    let isSenderMessage: Bool
    let avatar: String?
    let date: String
    let content: ContentType

    init(currentUser: User, message: Message) {
        self.id = message.id
        self.isSenderMessage = currentUser.id == message.sender.id
        self.avatar = message.sender.avatar
        self.date = message.createdAt.string(withFormat: "HH:mm")
        switch message.type {
        default:
            self.content = .plaintext(
                PlaintextMessageContentItemModel(
                    currentUser: currentUser,
                    message: message
                )
            )
        }
    }

    init(id: Int,
         isSenderMessage: Bool,
         avatar: String?,
         date: String,
         content: ContentType) {
        self.id = id
        self.isSenderMessage = isSenderMessage
        self.avatar = avatar
        self.date = date
        self.content = content
    }
}

// MARK: - ContentItemModelType

protocol ContentItemModelType {
    var isSenderMessage: Bool { get }
}

// MARK: - PlaintextMessageContentItemModel

struct PlaintextMessageContentItemModel: Equatable, ContentItemModelType {
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
