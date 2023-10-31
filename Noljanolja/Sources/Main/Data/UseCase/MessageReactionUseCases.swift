//
//  MessageReactionUseCase.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/06/2023.
//

import Combine
import Foundation

// MARK: - MessageReactionUseCases

protocol MessageReactionUseCases {
    func reactMessage(message: Message, reactionId: Int) -> AnyPublisher<Void, Error>
}

// MARK: - MessageReactionUseCasesImpl

final class MessageReactionUseCasesImpl: MessageReactionUseCases {
    static let shared = MessageReactionUseCasesImpl()

    private let messageAPI: MessageRepository

    init(messageAPI: MessageRepository = MessageRepositoryImpl.default) {
        self.messageAPI = messageAPI
    }

    func reactMessage(message: Message, reactionId: Int) -> AnyPublisher<Void, Error> {
        guard let messageId = message.id else {
            return Fail(error: CommonError.unknown).eraseToAnyPublisher()
        }
        return messageAPI
            .reactMessage(
                conversationID: message.conversationID,
                messageID: messageId,
                reactionId: reactionId
            )
    }
}
