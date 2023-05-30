//
//  EventMessageModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/04/2023.
//

import Foundation

struct EventMessageModel: Equatable {
    let message: String

    init?(currentUser: User, message: Message) {
        switch message.type {
        case .plaintext, .photo, .sticker, .unknown:
            return nil
        case .eventUpdated:
            self.message = L10n.conversationHasChanged
        case .eventJoined:
            let senderName = message.sender.getDisplayName(currentUser: currentUser)
            let participantNames = message.joinParticipants.getDisplayName(currentUser: currentUser)
            self.message = L10n.chatMessageEventJoined(senderName, participantNames)
        case .eventLeft:
            let participantNames = message.leftParticipants.getDisplayName(currentUser: currentUser)
            let tobe = participantNames.count > 1 ? "have" : "has"
            let action = "left the conversation"
            self.message = L10n.chatMessageEventLeft(participantNames)
        }
    }
}
