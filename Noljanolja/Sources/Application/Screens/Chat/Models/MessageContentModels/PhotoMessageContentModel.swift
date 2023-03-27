//
//  Photo.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 24/03/2023.
//

import Foundation

// MARK: - TextMessageContentModel

struct PhotoMessageContentModel: Equatable, MessageContentModelType {
    let isSenderMessage: Bool
    let photos: [String]

    init(currentUser: User, message: Message) {
        self.isSenderMessage = currentUser.id == message.sender.id
        self.photos = message.attachments.map { attachment in
            ConversationAPI.default.getAttachmentURL(conversationID: message.conversationID, attachmentID: attachment.id)
        }
    }

    init(isSenderMessage: Bool, photos: [String]) {
        self.isSenderMessage = isSenderMessage
        self.photos = photos
    }
}
