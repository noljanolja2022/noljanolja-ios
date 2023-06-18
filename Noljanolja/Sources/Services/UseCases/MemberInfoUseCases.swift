//
//  MemberShipUseCase.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 17/06/2023.
//

import Combine
import Foundation

// MARK: - MemberInfoUseCases

protocol MemberInfoUseCases {
    func getLoyaltyMemberInfo() -> AnyPublisher<LoyaltyMemberInfo, Error>
}

// MARK: - MemberInfoUseCasesImpl

final class MemberInfoUseCasesImpl: MemberInfoUseCases {
    static let `default` = MemberInfoUseCasesImpl()

    // MARK: Dependencies

    private let loyaltyApi: LoyaltyAPIType

    // MARK: Private

    private let memberInfoSubject = CurrentValueSubject<LoyaltyMemberInfo?, Never>(nil)

    init(loyaltyApi: LoyaltyAPIType = LoyaltyAPI.default) {
        self.loyaltyApi = loyaltyApi
    }

    func getLoyaltyMemberInfo() -> AnyPublisher<LoyaltyMemberInfo, Error> {
        loyaltyApi
            .getLoyaltyMemberInfo()
            .flatMapLatest { [weak self] memberInfo in
                guard let self else {
                    return Empty<LoyaltyMemberInfo, Error>().eraseToAnyPublisher()
                }
                self.memberInfoSubject.send(memberInfo)
                return self.memberInfoSubject
                    .compactMap { $0 }
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
