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

    private let userAPI: UserAPIType
    private let conversationUseCases: ConversationUseCases

    init(userAPI: UserAPIType = UserAPI.default,
         conversationUseCases: ConversationUseCases = ConversationUseCasesImpl.default) {
        self.userAPI = userAPI
        self.conversationUseCases = conversationUseCases
    }

    func addFriend(user: User) -> AnyPublisher<Conversation, Error> {
        userAPI
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
