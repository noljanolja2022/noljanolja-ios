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

    private let localContactAPI: LocalContactAPIType
    private let contactAPI: ContactAPIType
    private let contactStore: ContactStoreType

    private init(localContactAPI: LocalContactAPIType = LocalContactAPI.default,
                 contactAPI: ContactAPIType = ContactAPI.default,
                 contactStore: ContactStoreType = ContactStore.default) {
        self.localContactAPI = localContactAPI
        self.contactAPI = contactAPI
        self.contactStore = contactStore
    }

    func getAuthorizationStatus() -> AnyPublisher<Void, Error> {
        localContactAPI.getAuthorizationStatus()
    }

    func requestContactPermission() -> AnyPublisher<Bool, Error> {
        localContactAPI.requestContactPermission()
    }

    func getContacts() -> AnyPublisher<[User], Error> {
        let remoteContacts = localContactAPI
            .getContacts()
            .map { $0.filter { !$0.phones.isEmpty } }
            .flatMap { [weak self] contacts -> AnyPublisher<[User], Error> in
                guard let self else {
                    return Empty<[User], Error>().eraseToAnyPublisher()
                }
                return self.contactAPI
                    .syncContacts(contacts)
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.contactStore.saveContact($0)
            })

        return remoteContacts
            .eraseToAnyPublisher()

//        let localContacts = contactStore.observeContacts()
//            .filter { !$0.isEmpty }
//
//        return Publishers.Merge(remoteContacts, localContacts)
//            .removeDuplicates()
//            .eraseToAnyPublisher()
    }
}
