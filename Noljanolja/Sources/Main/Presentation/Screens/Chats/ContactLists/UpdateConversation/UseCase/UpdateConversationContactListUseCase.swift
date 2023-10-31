//
//  UpdateConversationContactListUseCases.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import Combine
import Foundation

final class UpdateConversationContactListUseCases: ContactListUseCases {
    private let conversation: Conversation
    private let contactUseCases: ContactUseCases

    init(conversation: Conversation,
         contactUseCases: ContactUseCases = ContactUseCasesImpl.default) {
        self.conversation = conversation
        self.contactUseCases = contactUseCases
    }

    func getContacts(page: Int, pageSize: Int) -> AnyPublisher<[User], Error> {
        let conversation = conversation
        return contactUseCases
            .getContacts(page: page, pageSize: pageSize)
            .map { users in
                users.filter { user in
                    !conversation.participants.contains(where: { $0.id == user.id })
                }
            }
            .eraseToAnyPublisher()
    }
}
