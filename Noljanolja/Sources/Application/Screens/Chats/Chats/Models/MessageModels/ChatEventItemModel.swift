//
//  EventMessageItemModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/04/2023.
//

import Foundation

struct EventChatItemModel: Equatable {
    let message: String

    init?(currentUser: User, message: Message) {
        switch message.type {
        case .plaintext, .photo, .sticker, .unknown:
            return nil
        case .eventUpdated:
            let senderName = message.sender.getDisplayName(currentUser: currentUser)
            let action = "has updated conversation"
            let title = ""
            self.message = [senderName, action, title].compactMap { $0 }.joined(separator: " ")
        case .eventJoined:
            let senderName = message.sender.getDisplayName(currentUser: currentUser)
            let action = "has invited"
            let participantNames = message.joinParticipants.getDisplayName(currentUser: currentUser)
            self.message = [senderName, action, participantNames].compactMap { $0 }.joined(separator: " ")
        case .eventLeft:
            let participantNames = message.leftParticipants.getDisplayName(currentUser: currentUser)
            let action = "has left the conversation"
            self.message = [participantNames, action].compactMap { $0 }.joined(separator: " ")
        }
    }
}
