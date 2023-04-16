//
//  CreateConversationContactListUseCase.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import Combine
import Foundation

final class CreateConversationContactListUseCase: ContactListUseCase {
    private let contactService: ContactServiceType

    init(contactService: ContactServiceType = ContactService.default) {
        self.contactService = contactService
    }

    func getContacts(page: Int, pageSize: Int) -> AnyPublisher<[User], Error> {
        contactService.getContacts(page: page, pageSize: pageSize)
    }
}
