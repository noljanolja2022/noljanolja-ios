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
    private let conversationService: ConversationServiceType

    init(userAPI: UserAPIType = UserAPI.default,
         conversationService: ConversationServiceType = ConversationService.default) {
        self.userAPI = userAPI
        self.conversationService = conversationService
    }

    func addFriend(user: User) -> AnyPublisher<Conversation, Error> {
        userAPI
            .inviteUser(id: user.id)
            .flatMap { [weak self] in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationService
                    .createConversation(type: .single, participants: [user])
            }
            .eraseToAnyPublisher()
    }
}
