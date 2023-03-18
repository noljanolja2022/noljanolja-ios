//
//  ContactService.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/03/2023.
//

import Combine
import Foundation

// MARK: - ContactServiceType

protocol ContactServiceType {
    func getAuthorizationStatus() -> AnyPublisher<Void, Error>
    func requestContactPermission() -> AnyPublisher<Bool, Error>
    func getContacts() -> AnyPublisher<[User], Error>
}

// MARK: - ContactService

final class ContactService: ContactServiceType {
    static let `default` = ContactService()

    private let contactAPI: ContactAPIType
    private let userAPI: UserAPIType
    private let contactStore: ContactStoreType

    private init(contactAPI: ContactAPIType = ContactAPI.default,
                 userAPI: UserAPIType = UserAPI.default,
                 contactStore: ContactStoreType = ContactStore.default) {
        self.contactAPI = contactAPI
        self.userAPI = userAPI
        self.contactStore = contactStore
    }

    func getAuthorizationStatus() -> AnyPublisher<Void, Error> {
        contactAPI.getAuthorizationStatus()
    }

    func requestContactPermission() -> AnyPublisher<Bool, Error> {
        contactAPI.requestContactPermission()
    }

    func getContacts() -> AnyPublisher<[User], Error> {
        let localContacts = contactStore.observeContacts()
            .filter { !$0.isEmpty }

        let remoteContacts = contactAPI
            .getContacts()
            .map { $0.filter { !$0.phones.isEmpty } }
            .flatMap { [weak self] contacts -> AnyPublisher<[User], Error> in
                guard let self else {
                    return Empty<[User], Error>().eraseToAnyPublisher()
                }
                return self.userAPI
                    .syncContacts(contacts)
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.contactStore.saveContact($0)
            })

        return Publishers.Merge(localContacts, remoteContacts)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
