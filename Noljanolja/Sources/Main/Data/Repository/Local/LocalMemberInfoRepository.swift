//
//  LocalMemberInfoRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 17/06/2023.
//

import Combine
import Foundation

// MARK: - LocalMemberInfoRepository

protocol LocalMemberInfoRepository {
    func getMemberInfo() -> AnyPublisher<LoyaltyMemberInfo?, Never>
    func updateMemberInfo(_ memberInfo: LoyaltyMemberInfo)
}

// MARK: - LocalMemberInfoRepositoryImpl

final class LocalMemberInfoRepositoryImpl: LocalMemberInfoRepository {
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
