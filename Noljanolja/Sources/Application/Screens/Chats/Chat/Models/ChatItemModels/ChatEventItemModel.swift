//
//  EventMessageItemModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/04/2023.
//

import Foundation

struct ChatEventItemModel: Equatable {
    let message: String

    init?(currentUser: User, message: Message) {
        switch message.type {
        case .plaintext, .photo, .sticker, .unknown:
            return nil
        case .eventUpdated:
            self.message = "Conversation has changed"
        case .eventJoined:
            let senderName = message.sender.getDisplayName(currentUser: currentUser)
            let action = "has invited"
            let participantNames = message.joinParticipants.getDisplayName(currentUser: currentUser)
            self.message = [senderName, action, participantNames].compactMap { $0 }.joined(separator: " ")
        case .eventLeft:
            let participantNames = message.leftParticipants.getDisplayName(currentUser: currentUser)
            let tobe = participantNames.count > 1 ? "have" : "has"
            let action = "left the conversation"
            self.message = [participantNames, tobe, action]
                .joined(separator: " ")
        }
    }
}
