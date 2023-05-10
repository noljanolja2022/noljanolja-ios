//
//  ChatItemModelBuilder.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import Foundation
import SwiftUI

final class ChatItemModelBuilder {
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
            let statusType = buildStatusType(index: index, message: message)

            let messageModel = MessageChatItemModel(
                currentUser: currentUser,
                conversation: conversation,
                message: message,
                positionType: positionType,
                status: statusType
            )
            messageModel.flatMap {
                messageItemTypes.append(.message($0))
            }

            let isFirstMessageByDate = beforceMessage
                .flatMap { !Calendar.current.isDate(message.createdAt, equalTo: $0.createdAt, toGranularity: .day) } ?? true

            if isFirstMessageByDate {
                messageItemTypes.append(
                    .date(DateChatItemModel(message: message))
                )
            }
        }

        return messageItemTypes
    }

    private func buildPositionType(beforceMessage: Message?,
                                   message: Message,
                                   afterMessage: Message?) -> NormalMessageModel.PositionType {
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
            return [.first, .last]
        } else if isFirstMessageByDate || isFirstMessageBySender {
            return [.first]
        } else if isLastMessageByDate || isLastMessageBySender {
            return [.last]
        } else {
            return [.middle]
        }
    }

    private func buildStatusType(index: Int, message: Message) -> NormalMessageModel.StatusType {
        let seenUserLastIndexes = conversation.participants
            .reduce([String: Int]()) { result, user -> [String: Int] in
                let index = messages.firstIndex { message in
                    message.seenBy.contains(user.id)
                }
                if let index {
                    return result.merging([user.id: index], uniquingKeysWith: { $1 })
                } else {
                    return result
                }
            }

        let seenUsers = conversation.participants
            .filter { user in
                if let seenUserLastIndex = seenUserLastIndexes[user.id] {
                    return index >= seenUserLastIndex
                } else {
                    return false
                }
            }

        if !seenUsers.isEmpty {
            return .seen(seenUsers)
        } else if message.id != nil {
            return .sent
        } else if message.id == nil {
            return .sending
        } else {
            return .none
        }
    }
}
