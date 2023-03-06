//
//  ContactService.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//

import Combine
import Contacts
import Foundation

// MARK: - ContactServiceType

protocol ContactServiceType {
    func requestContactPermission() -> AnyPublisher<Bool, Error>
    func getContacts() -> AnyPublisher<[ContactModel], Error>
}

// MARK: - ContactsError

enum ContactsError: Error {
    case permissionNotDetermined
    case permissionDenied
    case unknown

    var isPermissionError: Bool {
        switch self {
        case .permissionNotDetermined, .permissionDenied: return true
        case .unknown: return false
        }
    }
}

// MARK: - ContactService

final class ContactService: ContactServiceType {
    static let `default` = ContactService()

    private lazy var store = CNContactStore()

    private init() {}

    func requestContactPermission() -> AnyPublisher<Bool, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(ContactsError.unknown))
                return
            }
            self.store.requestAccess(for: .contacts) { isGranted, error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(isGranted))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func getContacts() -> AnyPublisher<[ContactModel], Error> {
        getAuthorizationStatus()
            .flatMap { [weak self] _ -> AnyPublisher<[ContactModel], Error> in
                guard let self else {
                    return Fail<[ContactModel], Error>(error: ContactsError.unknown).eraseToAnyPublisher()
                }
                return self.fetchContacts()
            }
            .eraseToAnyPublisher()
    }

    private func getAuthorizationStatus() -> AnyPublisher<Void, Error> {
        Future { promise in
            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .authorized, .restricted:
                promise(.success(()))
            case .notDetermined:
                promise(.failure(ContactsError.permissionNotDetermined))
            case .denied:
                promise(.failure(ContactsError.permissionDenied))
            @unknown default:
                promise(.failure(ContactsError.unknown))
            }
        }
        .eraseToAnyPublisher()
    }

    private func fetchContacts() -> AnyPublisher<[ContactModel], Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(ContactsError.unknown))
                return
            }

            do {
                let containers = try self.store.containers(matching: nil)
                var allContacts = [CNContact]()
                containers
                    .forEach {
                        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: $0.identifier)
                        let keys = [
                            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                            CNContactFormatter.descriptorForRequiredKeys(for: .phoneticFullName),
                            CNContactImageDataKey as CNKeyDescriptor,
                            CNContactThumbnailImageDataKey as CNKeyDescriptor
                        ]
                        do {
                            let contacts = try self.store.unifiedContacts(matching: predicate, keysToFetch: keys)
                            allContacts.append(contentsOf: contacts)
                        } catch {
                            promise(.failure(error))
                            return
                        }
                    }
                promise(.success(allContacts.map { ContactModel($0) }))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
