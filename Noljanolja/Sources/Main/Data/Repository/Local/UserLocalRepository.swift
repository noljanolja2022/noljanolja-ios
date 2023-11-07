//
//  UserLocalRepositoryImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 17/04/2023.
//

import Combine
import Foundation

// MARK: - UserLocalRepository

protocol UserLocalRepository {
    func saveCurrentUser(_ user: User)
    
    func getCurrentUser() -> User?
    func getCurrentUserPublisher() -> AnyPublisher<User, Never>
}

// MARK: - UserLocalRepositoryImpl

final class UserLocalRepositoryImpl: UserLocalRepository {
    static let `default` = UserLocalRepositoryImpl()

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
