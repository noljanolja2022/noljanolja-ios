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
    func getContacts(page: Int, pageSize: Int) -> AnyPublisher<[User], Error>
}

// MARK: - ContactService

final class ContactService: ContactServiceType {
    static let `default` = ContactService()

    private let contactRepository: ContactRepository
    private let userAPI: UserAPIType
    private let contactStore: ContactStoreType

    private init(contactRepository: ContactRepository = ContactRepositoryImpl.default,
                 userAPI: UserAPIType = UserAPI.default,
                 contactStore: ContactStoreType = ContactStore.default) {
        self.contactRepository = contactRepository
        self.userAPI = userAPI
        self.contactStore = contactStore
    }

    func getAuthorizationStatus() -> AnyPublisher<Void, Error> {
        contactRepository.getAuthorizationStatus()
    }

    func requestContactPermission() -> AnyPublisher<Bool, Error> {
        contactRepository.requestContactPermission()
    }

    func getContacts(page: Int, pageSize: Int) -> AnyPublisher<[User], Error> {
        contactRepository.getAuthorizationStatus()
            .flatMapLatest { [weak self] _ -> AnyPublisher<[User], Error> in
                guard let self else {
                    return Fail(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }

                let localContacts = contactStore.observeContacts()
                    .filter { !$0.isEmpty }

                let remoteGetContacts = getRemoteContacts(page: page, pageSize: pageSize)

                let remoteSyncContacts = syncContacts()
                    .flatMapLatest { [weak self] _ -> AnyPublisher<[User], Error> in
                        guard let self else {
                            return Fail(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                        }
                        return self.getRemoteContacts(page: page, pageSize: pageSize)
                    }

                return Publishers.Merge3(localContacts, remoteGetContacts, remoteSyncContacts)
                    .map { $0.sorted { $0.name ?? "" < $1.name ?? "" } }
                    .removeDuplicates()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

extension ContactService {
    private func syncContacts() -> AnyPublisher<[User], Error> {
        contactRepository
            .getContacts()
            .flatMapLatest { [weak self] contacts -> AnyPublisher<[User], Error> in
                guard let self else {
                    return Fail(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }
                return self.userAPI
                    .syncContacts(contacts.filter { !$0.phones.isEmpty })
            }
            .eraseToAnyPublisher()
    }

    private func getRemoteContacts(page: Int, pageSize: Int) -> AnyPublisher<[User], Error> {
        userAPI
            .getContact(page: page, pageSize: pageSize)
            .handleEvents(receiveOutput: { [weak self] in
                self?.contactStore.saveContact($0)
            })
            .eraseToAnyPublisher()
    }
}
