//
//  UserServices.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//

import Combine
import CombineExt
import Foundation

// MARK: - UserServiceType

protocol UserServiceType {
    var currentUser: User? { get }
    var currentUserPublisher: AnyPublisher<User, Never> { get }

    func getCurrentUser() -> AnyPublisher<User, Error>
    func updateCurrentUser(_ param: UpdateCurrentUserParam) -> AnyPublisher<User, Error>
}

// MARK: - UserService

final class UserService: UserServiceType {
    static let `default` = UserService()

    // MARK: Dependencies

    private let userAPI: UserAPIType

    // MARK: Type

    var currentUser: User? {
        currentUserSubject.value
    }

    var currentUserPublisher: AnyPublisher<User, Never> {
        currentUserSubject
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    // MARK: Private

    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)

    init(userAPI: UserAPIType = UserAPI.default) {
        self.userAPI = userAPI
    }

    func getCurrentUser() -> AnyPublisher<User, Error> {
        userAPI
            .getCurrentUser()
            .handleEvents(receiveOutput: { [weak self] in self?.currentUserSubject.send($0) })
            .eraseToAnyPublisher()
    }

    func updateCurrentUser(_ param: UpdateCurrentUserParam) -> AnyPublisher<User, Error> {
        userAPI
            .updateCurrentUser(param)
            .handleEvents(receiveOutput: { [weak self] in self?.currentUserSubject.send($0) })
            .eraseToAnyPublisher()
    }
}
