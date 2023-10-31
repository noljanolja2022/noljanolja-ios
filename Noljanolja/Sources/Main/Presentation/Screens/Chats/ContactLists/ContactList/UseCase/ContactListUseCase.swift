//
//  ContactListUseCases.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import Combine
import Foundation

// MARK: - ContactListUseCases

protocol ContactListUseCases {
    func getContacts(page: Int, pageSize: Int) -> AnyPublisher<[User], Error>
}

// MARK: - ContactListUseCasesImpl

final class ContactListUseCasesImpl: ContactListUseCases {
    private let contactUseCases: ContactUseCases

    init(contactUseCases: ContactUseCases = ContactUseCasesImpl.default) {
        self.contactUseCases = contactUseCases
    }

    func getContacts(page: Int, pageSize: Int) -> AnyPublisher<[User], Error> {
        contactUseCases.getContacts(page: page, pageSize: pageSize)
    }
}
