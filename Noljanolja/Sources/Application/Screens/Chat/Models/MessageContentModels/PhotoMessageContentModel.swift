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
    let photos: [URL?]

    init(currentUser: User, message: Message) {
        self.isSenderMessage = message.sender.id == currentUser.id
        self.photos = message.attachments.map { attachment in
            attachment.getPhotoURL(conversationID: message.conversationID)
        }
    }

    init(isSenderMessage: Bool, photos: [URL?]) {
        self.isSenderMessage = isSenderMessage
        self.photos = photos
    }
}
