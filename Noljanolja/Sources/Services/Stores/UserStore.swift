//
//  UserStore.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 17/04/2023.
//

import Combine
import Foundation

// MARK: - UserStoreType

protocol UserStoreType {
    func saveCurrentUser(_ user: User)
    
    func getCurrentUser() -> User?
    func getCurrentUserPublisher() -> AnyPublisher<User, Never>
}

// MARK: - UserStore

final class UserStore: UserStoreType {
    static let `default` = UserStore()

    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)

    func saveCurrentUser(_ user: User) {
        currentUserSubject.send(user)
    }

    func getCurrentUser() -> User? {
        currentUserSubject.value
    }

    func getCurrentUserPublisher() -> AnyPublisher<User, Never> {
        currentUserSubject
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
