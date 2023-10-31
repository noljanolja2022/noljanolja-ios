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

    private let messageNetworkRepository: MessageNetworkRepository

    init(messageNetworkRepository: MessageNetworkRepository = MessageNetworkRepositoryImpl.default) {
        self.messageNetworkRepository = messageNetworkRepository
    }

    func reactMessage(message: Message, reactionId: Int) -> AnyPublisher<Void, Error> {
        guard let messageId = message.id else {
            return Fail(error: CommonError.unknown).eraseToAnyPublisher()
        }
        return messageNetworkRepository
            .reactMessage(
                conversationID: message.conversationID,
                messageID: messageId,
                reactionId: reactionId
            )
    }
}
