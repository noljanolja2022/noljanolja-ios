//
//  MessageItemModelBuilder.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import Foundation
import SwiftUI

final class MessageItemModelBuilder {
    private let currentUser: User
    private let conversation: Conversation
    private let messages: [Message]

    init(currentUser: User, conversation: Conversation, messages: [Message]) {
        self.currentUser = currentUser
        self.conversation = conversation
        self.messages = messages
    }

    func build() -> [ChatItemModelType] {
        var messageItemTypes = [ChatItemModelType]()

        for (index, message) in messages.enumerated() {
            let beforceMessage = messages[safe: index + 1]
            let afterMessage = messages[safe: index - 1]

            let positionType = buildPositionType(beforceMessage: beforceMessage, message: message, afterMessage: afterMessage)
            let statusType = buildStatusType(message: message)

            let messageChatItemModel = MessageChatItemModel(
                currentUser: currentUser,
                message: message,
                positionType: positionType,
                status: statusType
            )
            messageChatItemModel.flatMap {
                messageItemTypes.append(.item($0))
            }

            let eventChatItemModel = EventChatItemModel(currentUser: currentUser, message: message)
            eventChatItemModel.flatMap {
                messageItemTypes.append(.event($0))
            }

            let isFirstMessageByDate = beforceMessage
                .flatMap { !Calendar.current.isDate(message.createdAt, equalTo: $0.createdAt, toGranularity: .day) } ?? true

            if isFirstMessageByDate {
                messageItemTypes.append(
                    .date(ChatDateItemModel(message: message))
                )
            }
        }

        return messageItemTypes
    }

    private func buildPositionType(beforceMessage: Message?,
                                   message: Message,
                                   afterMessage: Message?) -> MessageChatItemModel.PositionType {
        let isFirstMessageByDate = beforceMessage
            .flatMap { !Calendar.current.isDate(message.createdAt, equalTo: $0.createdAt, toGranularity: .day) } ?? true
        let isLastMessageByDate = afterMessage
            .flatMap { !Calendar.current.isDate(message.createdAt, equalTo: $0.createdAt, toGranularity: .day) } ?? true
        let isFirstMessageBySender = beforceMessage
            .flatMap { message.sender.id != $0.sender.id } ?? true
        let isLastMessageBySender = afterMessage
            .flatMap { message.sender.id != $0.sender.id } ?? true

        if (isFirstMessageByDate && isLastMessageByDate)
            || (isFirstMessageBySender && isLastMessageBySender) {
            return .all
        } else if isFirstMessageByDate || isFirstMessageBySender {
            return .first
        } else if isLastMessageByDate || isLastMessageBySender {
            return .last
        } else {
            return .middle
        }
    }

    private func buildStatusType(message: Message) -> MessageChatItemModel.StatusType {
        let currentUser = currentUser
        let lastSenderSentMessage = messages.first(where: { $0.id != nil && $0.sender.id == currentUser.id })
        let lastSenderSeenMessage = messages
            .first(where: { message in
                message.sender.id == currentUser.id
                    && !message.seenBy.filter { $0 != currentUser.id }.isEmpty
            })
        if message.id == nil {
            return .sending
        } else if message.id == lastSenderSeenMessage?.id {
            let users = conversation.participants.filter { $0.id != currentUser.id }
            return .seen(users)
        } else if message.id == lastSenderSentMessage?.id {
            return .received
        } else {
            return .none
        }
    }
}
