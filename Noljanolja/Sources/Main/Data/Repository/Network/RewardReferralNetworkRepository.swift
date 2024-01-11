//
//  RewardReferalNetworkRepository.swift
//  Noljanolja
//
//  Created by duydinhv on 11/01/2024.
//

import Combine
import Moya

// MARK: - RewardReferralTargets

private enum RewardReferralTargets {
    struct GetReferralPoints: BaseAuthTargetType {
        var path: String { "v1/reward/referral/configs" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }
    }
}

// MARK: - RewardReferralNetworkRepository

protocol RewardReferralNetworkRepository {
    func getReferralPoints() -> AnyPublisher<ReferralPointsConfig, Error>
}

// MARK: - RewardReferralNetworkRepositoryImpl

final class RewardReferralNetworkRepositoryImpl: RewardReferralNetworkRepository {
    static let shared: RewardReferralNetworkRepository = RewardReferralNetworkRepositoryImpl()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getReferralPoints() -> AnyPublisher<ReferralPointsConfig, Error> {
        api.request(
            target: RewardReferralTargets.GetReferralPoints(),
            atKeyPath: "data"
        )
    }
}
