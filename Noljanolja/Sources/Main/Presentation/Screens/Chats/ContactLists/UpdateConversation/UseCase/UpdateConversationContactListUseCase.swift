//
//  UpdateConversationContactListUseCase.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import Combine
import Foundation

final class UpdateConversationContactListUseCase: ContactListUseCase {
    private let conversation: Conversation
    private let contactService: ContactServiceType

    init(conversation: Conversation,
         contactService: ContactServiceType = ContactService.default) {
        self.conversation = conversation
        self.contactService = contactService
    }

    func getContacts(page: Int, pageSize: Int) -> AnyPublisher<[User], Error> {
        let conversation = conversation
        return contactService
            .getContacts(page: page, pageSize: pageSize)
            .map { users in
                users.filter { user in
                    !conversation.participants.contains(where: { $0.id == user.id })
                }
            }
            .eraseToAnyPublisher()
    }
}
