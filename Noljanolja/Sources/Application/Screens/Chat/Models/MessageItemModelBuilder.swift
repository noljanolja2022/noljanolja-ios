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
    private let messages: [Message]

    init(currentUser: User, messages: [Message]) {
        self.currentUser = currentUser
        self.messages = messages
    }

    func build() -> [ChatItemModelType] {
        var messageItemTypes = [ChatItemModelType]()

        messages.enumerated().forEach { index, message in
            let beforceMessage = messages[safe: index + 1]
            let afterMessage = messages[safe: index - 1]

            let positionType = buildPositionType(beforceMessage: beforceMessage, message: message, afterMessage: afterMessage)

            messageItemTypes.append(
                .item(ChatMessageItemModel(currentUser: currentUser, message: message, positionType: positionType))
            )

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
                                   afterMessage: Message?) -> ChatMessageItemModel.PositionType {
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
}
