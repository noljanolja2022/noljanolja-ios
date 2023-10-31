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
}

// MARK: - ContactUseCasesImpl

final class ContactUseCasesImpl: ContactUseCases {
    static let `default` = ContactUseCasesImpl()

    private let networkContactRepository: NetworkContactRepository
    private let localContactRepository: LocalContactRepository
    private let userAPI: UserAPIType

    private init(networkContactRepository: NetworkContactRepository = NetworkContactRepositoryImpl.default,
                 localContactRepository: LocalContactRepository = LocalContactRepositoryImpl.default,
                 userAPI: UserAPIType = UserAPI.default) {
        self.networkContactRepository = networkContactRepository
        self.localContactRepository = localContactRepository
        self.userAPI = userAPI
    }

    func getAuthorizationStatus() -> AnyPublisher<Void, Error> {
        networkContactRepository.getAuthorizationStatus()
    }

    func requestContactPermission() -> AnyPublisher<Bool, Error> {
        networkContactRepository.requestContactPermission()
    }

    func getContacts(page: Int, pageSize: Int) -> AnyPublisher<[User], Error> {
        networkContactRepository.getAuthorizationStatus()
            .flatMapLatest { [weak self] _ -> AnyPublisher<[User], Error> in
                guard let self else {
                    return Fail(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }

                let localContacts = localContactRepository.observeContacts()
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

extension ContactUseCasesImpl {
    private func syncContacts() -> AnyPublisher<[User], Error> {
        networkContactRepository
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
                self?.localContactRepository.saveContact($0)
            })
            .eraseToAnyPublisher()
    }
}
