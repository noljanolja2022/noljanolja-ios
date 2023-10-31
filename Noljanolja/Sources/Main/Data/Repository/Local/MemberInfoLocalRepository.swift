//
//  MemberInfoLocalRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 17/06/2023.
//

import Combine
import Foundation

// MARK: - MemberInfoLocalRepository

protocol MemberInfoLocalRepository {
    func getMemberInfo() -> AnyPublisher<LoyaltyMemberInfo?, Never>
    func updateMemberInfo(_ memberInfo: LoyaltyMemberInfo)
}

// MARK: - MemberInfoLocalRepositoryImpl

final class MemberInfoLocalRepositoryImpl: MemberInfoLocalRepository {
    private let memberInfoSubject = CurrentValueSubject<LoyaltyMemberInfo?, Never>(nil)

    func getMemberInfo() -> AnyPublisher<LoyaltyMemberInfo?, Never> {
        memberInfoSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    func updateMemberInfo(_ memberInfo: LoyaltyMemberInfo) {
        memberInfoSubject.send(memberInfo)
    }
}
