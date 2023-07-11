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
    private let reactionIcons: [ReactIcon]
    private let messages: [Message]

    init(currentUser: User, conversation: Conversation, reactionIcons: [ReactIcon], messages: [Message]) {
        self.currentUser = currentUser
        self.conversation = conversation
        self.reactionIcons = reactionIcons
        self.messages = messages
    }

    func build() -> [ChatItemModelType] {
        var messageItemTypes = [ChatItemModelType]()

        messages.enumerated().forEach { index, message in
            let beforceMessage = messages[safe: index + 1]
            let afterMessage = messages[safe: index - 1]
            let positionTypeByBlock = buildPositionTypeByBlock(beforceMessage: beforceMessage, message: message, afterMessage: afterMessage)
            let positionTypeBySenderType = buildPositionTypeBySenderType(message: message)

            let statusType: NormalMessageModel.StatusType = {
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
                return buildStatusType(
                    currentUser: currentUser,
                    message: message,
                    index: index,
                    seenUserLastIndexes: seenUserLastIndexes
                )
            }()

            let messageModel = MessageChatItemModel(
                currentUser: currentUser,
                conversation: conversation,
                reactionIcons: reactionIcons,
                message: message,
                positionTypeByBlock: positionTypeByBlock,
                positionTypeBySenderType: positionTypeBySenderType,
                status: statusType
            )
            messageModel.flatMap {
                messageItemTypes.append(.message($0))
            }

            let isSameDateWithBeforceMessage = beforceMessage
                .flatMap { Calendar.current.isDate(message.createdAt, equalTo: $0.createdAt, toGranularity: .day) } ?? false
            if !isSameDateWithBeforceMessage {
                messageItemTypes.append(
                    .date(DateChatItemModel(message: message))
                )
            }
        }

        return messageItemTypes
    }

    private func buildPositionTypeByBlock(beforceMessage: Message?,
                                          message: Message,
                                          afterMessage: Message?) -> NormalMessageModel.PositionType {
        let isSameSessionByTypeWithBeforceMessage = message.type.isSessionEnabled == beforceMessage?.type.isSessionEnabled
        let isSameSessionByTypeWithAfterMessage = message.type.isSessionEnabled == afterMessage?.type.isSessionEnabled

        let isSameDateWithBeforceMessage = beforceMessage
            .flatMap { Calendar.current.isDate(message.createdAt, equalTo: $0.createdAt, toGranularity: .day) } ?? false
        let isSameDateWithAfterMessage = afterMessage
            .flatMap { Calendar.current.isDate(message.createdAt, equalTo: $0.createdAt, toGranularity: .day) } ?? false

        let isSameSenderWithBeforceMessage = message.sender.id == beforceMessage?.sender.id
        let isSameSenderWithAfterMessage = message.sender.id == afterMessage?.sender.id

        let isSameSessionWithBeforceMessage = !isSameSessionByTypeWithBeforceMessage
            || !isSameDateWithBeforceMessage
            || !isSameSenderWithBeforceMessage
        let isSameSessionWithAfterMessage = !isSameSessionByTypeWithAfterMessage
            || !isSameDateWithAfterMessage
            || !isSameSenderWithAfterMessage

        if isSameSessionWithBeforceMessage, isSameSessionWithAfterMessage {
            return [.first, .last]
        } else if isSameSessionWithBeforceMessage {
            return [.first]
        } else if isSameSessionWithAfterMessage {
            return [.last]
        } else {
            return [.middle]
        }
    }

    private func buildPositionTypeBySenderType(message: Message) -> NormalMessageModel.PositionType {
        let sessionableMessages = messages.filter { $0.type.isSessionEnabled }

        let currentUserMessages = sessionableMessages.filter { $0.sender.id == currentUser.id }
        let lastCurrentUserMessage = currentUserMessages.first
        let firstCurrentUserMessage = currentUserMessages.last

        let otherUserMessages = sessionableMessages.filter { $0.sender.id != currentUser.id }
        let lastOtherUserMessage = otherUserMessages.first
        let firstOtherUserMessage = otherUserMessages.last

        let isFirstMessageBySenderType = message == firstCurrentUserMessage || message == firstOtherUserMessage
        let isLastMessageBySenderType = message == lastCurrentUserMessage || message == lastOtherUserMessage

        if isFirstMessageBySenderType, isLastMessageBySenderType {
            return [.first, .last]
        } else if isFirstMessageBySenderType {
            return [.first]
        } else if isLastMessageBySenderType {
            return [.last]
        } else {
            return [.middle]
        }
    }

    private func buildStatusType(currentUser: User,
                                 message: Message,
                                 index: Int,
                                 seenUserLastIndexes: [String: Int]) -> NormalMessageModel.StatusType {
        let seenUsers = conversation.participants
            .filter { user in
                guard user.id != currentUser.id else {
                    return false
                }
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
