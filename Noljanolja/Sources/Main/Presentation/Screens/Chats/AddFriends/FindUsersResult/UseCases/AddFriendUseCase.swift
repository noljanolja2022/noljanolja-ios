//
//  AddFriendUseCase.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/06/2023.
//

import Combine
import Foundation

// MARK: - AddFriendUseCaseType

protocol AddFriendUseCaseType {
    func addFriend(user: User) -> AnyPublisher<Conversation, Error>
}

// MARK: - AddFriendUseCase

final class AddFriendUseCase: AddFriendUseCaseType {
    static let `default` = AddFriendUseCase()

    private let userNetworkRepository: UserNetworkRepository
    private let conversationUseCases: ConversationUseCases

    init(userNetworkRepository: UserNetworkRepository = UserNetworkRepositoryImpl.default,
         conversationUseCases: ConversationUseCases = ConversationUseCasesImpl.default) {
        self.userNetworkRepository = userNetworkRepository
        self.conversationUseCases = conversationUseCases
    }

    func addFriend(user: User) -> AnyPublisher<Conversation, Error> {
        userNetworkRepository
            .inviteUser(id: user.id)
            .flatMap { [weak self] in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationUseCases
                    .createConversation(type: .single, participants: [user])
            }
            .eraseToAnyPublisher()
    }
}
