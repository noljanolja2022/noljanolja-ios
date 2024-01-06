//
//  ContactUseCasesImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/03/2023.
//

import Combine
import Foundation

// MARK: - ContactUseCases

protocol ContactUseCases {
    func getAuthorizationStatus() -> AnyPublisher<Void, Error>
    func requestContactPermission() -> AnyPublisher<Bool, Error>
    func getContacts(page: Int, pageSize: Int) -> AnyPublisher<[User], Error>
    func getContactDetail(userId: String) -> AnyPublisher<ContactDetail, Error>
}

// MARK: - ContactUseCasesImpl

final class ContactUseCasesImpl: ContactUseCases {
    static let `default` = ContactUseCasesImpl()

    private let contactNetworkRepository: ContactNetworkRepository
    private let contactLocalRepository: ContactLocalRepository
    private let userNetworkRepository: UserNetworkRepository

    private init(contactNetworkRepository: ContactNetworkRepository = ContactNetworkRepositoryImpl.default,
                 contactLocalRepository: ContactLocalRepository = ContactLocalRepositoryImpl.default,
                 userNetworkRepository: UserNetworkRepository = UserNetworkRepositoryImpl.default) {
        self.contactNetworkRepository = contactNetworkRepository
        self.contactLocalRepository = contactLocalRepository
        self.userNetworkRepository = userNetworkRepository
    }

    func getAuthorizationStatus() -> AnyPublisher<Void, Error> {
        contactNetworkRepository.getAuthorizationStatus()
    }

    func requestContactPermission() -> AnyPublisher<Bool, Error> {
        contactNetworkRepository.requestContactPermission()
    }

    func getContacts(page: Int, pageSize: Int) -> AnyPublisher<[User], Error> {
        contactNetworkRepository.getAuthorizationStatus()
            .flatMapLatest { [weak self] _ -> AnyPublisher<[User], Error> in
                guard let self else {
                    return Fail(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }

                let localContacts = contactLocalRepository.observeContacts()
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

    func getContactDetail(userId: String) -> AnyPublisher<ContactDetail, Error> {
        userNetworkRepository
            .getContactDetail(userId: userId)
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

extension ContactUseCasesImpl {
    private func syncContacts() -> AnyPublisher<[User], Error> {
        contactNetworkRepository
            .getContacts()
            .flatMapLatest { [weak self] contacts -> AnyPublisher<[User], Error> in
                guard let self else {
                    return Fail(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }
                return self.userNetworkRepository
                    .syncContacts(contacts.filter { !$0.phones.isEmpty })
            }
            .eraseToAnyPublisher()
    }

    private func getRemoteContacts(page: Int, pageSize: Int) -> AnyPublisher<[User], Error> {
        userNetworkRepository
            .getContact(page: page, pageSize: pageSize)
            .handleEvents(receiveOutput: { [weak self] in
                self?.contactLocalRepository.saveContact($0)
            })
            .eraseToAnyPublisher()
    }
}
