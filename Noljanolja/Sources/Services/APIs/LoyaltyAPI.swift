//
//  LoyaltyAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/05/2023.
//

import Combine
import Foundation
import Moya

// MARK: - LoyaltyAPITargets

private enum LoyaltyAPITargets {
    struct GetLoyaltyMemberInfo: BaseAuthTargetType {
        var path: String { "v1/loyalty/me" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }
    }
}

// MARK: - LoyaltyAPIType

protocol LoyaltyAPIType {
    func getLoyaltyMemberInfo() -> AnyPublisher<LoyaltyMemberInfo, Error>
}

// MARK: - LoyaltyAPI

final class LoyaltyAPI: LoyaltyAPIType {
    static let `default` = LoyaltyAPI()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getLoyaltyMemberInfo() -> AnyPublisher<LoyaltyMemberInfo, Error> {
        api.request(
            target: LoyaltyAPITargets.GetLoyaltyMemberInfo(),
            atKeyPath: "data"
        )
    }
}
