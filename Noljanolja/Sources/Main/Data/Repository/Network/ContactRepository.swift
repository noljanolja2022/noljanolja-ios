//
//  ContactRepositoryImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//

import Combine
import Contacts
import Foundation

// MARK: - ContactRepository

protocol ContactRepository {
    func getAuthorizationStatus() -> AnyPublisher<Void, Error>
    func requestContactPermission() -> AnyPublisher<Bool, Error>
    func getContacts() -> AnyPublisher<[Contact], Error>
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

// MARK: - ContactRepositoryImpl

final class ContactRepositoryImpl: ContactRepository {
    static let `default` = ContactRepositoryImpl()

    private lazy var store = CNContactStore()

    private init() {}

    func getAuthorizationStatus() -> AnyPublisher<Void, Error> {
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

    func requestContactPermission() -> AnyPublisher<Bool, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(ContactsError.unknown))
                return
            }
            self.store.requestAccess(for: .contacts) { isGranted, _ in
                promise(.success(isGranted))
            }
        }
        .eraseToAnyPublisher()
    }

    func getContacts() -> AnyPublisher<[Contact], Error> {
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
                            CNContactPhoneNumbersKey as CNKeyDescriptor,
                            CNContactEmailAddressesKey as CNKeyDescriptor
                        ]
                        do {
                            let contacts = try self.store.unifiedContacts(matching: predicate, keysToFetch: keys)
                            allContacts.append(contentsOf: contacts)
                        } catch {
                            promise(.failure(error))
                            return
                        }
                    }
                promise(.success(allContacts.map { Contact($0) }))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
