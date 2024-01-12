//
//  RewardReferralUseCases.swift
//  Noljanolja
//
//  Created by duydinhv on 05/01/2024.
//

import Combine
import Foundation

// MARK: - RewardReferralUseCases

protocol RewardReferralUseCases {
    func getReferralPoints() -> AnyPublisher<ReferralPointsConfig, Error>
}

// MARK: - RewardReferralUseCasesImpl

final class RewardReferralUseCasesImpl: RewardReferralUseCases {
    static let shared: RewardReferralUseCases = RewardReferralUseCasesImpl()

    // MARK: Dependencies

    private let rewardReferralNetworkRepository: RewardReferralNetworkRepository

    init(rewardReferralNetworkRepository: RewardReferralNetworkRepository = RewardReferralNetworkRepositoryImpl.shared) {
        self.rewardReferralNetworkRepository = rewardReferralNetworkRepository
    }

    func getReferralPoints() -> AnyPublisher<ReferralPointsConfig, Error> {
        rewardReferralNetworkRepository
            .getReferralPoints()
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
