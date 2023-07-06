//
//  MessageChatItemModelType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/05/2023.
//

import Foundation

enum MessageChatItemModel: Equatable {
    case normal(NormalMessageModel)
    case event(EventMessageModel)

    init?(currentUser: User,
          conversation: Conversation,
          reactionIcons: [ReactIcon],
          message: Message,
          positionTypeByBlock: NormalMessageModel.PositionType,
          positionTypeBySenderType: NormalMessageModel.PositionType,
          status: NormalMessageModel.StatusType) {
        if let normalModel = NormalMessageModel(
            currentUser: currentUser,
            conversation: conversation,
            reactionIcons: reactionIcons,
            message: message,
            positionTypeByBlock: positionTypeByBlock,
            positionTypeBySenderType: positionTypeBySenderType,
            status: status
        ) {
            self = .normal(normalModel)
        } else if let eventModel = EventMessageModel(
            currentUser: currentUser,
            message: message
        ) {
            self = .event(eventModel)
        } else {
            return nil
        }
    }
}
