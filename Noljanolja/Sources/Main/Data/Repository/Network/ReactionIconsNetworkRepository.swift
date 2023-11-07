//
//  ReactionIconsNetworkRepositoryImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/06/2023.
//

import Combine
import Foundation
import Moya
import UIKit

// MARK: - ReactionIconsTargets

private enum ReactionIconsTargets {
    struct GetReactIcons: BaseAuthTargetType {
        var path: String { "v1/conversations/react-icons" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }
    }
}

// MARK: - ReactionIconsNetworkRepository

protocol ReactionIconsNetworkRepository {
    func getReactIcons() -> AnyPublisher<[ReactIcon], Error>
}

// MARK: - ReactionIconsNetworkRepositoryImpl

final class ReactionIconsNetworkRepositoryImpl: ReactionIconsNetworkRepository {
    static let `default` = ReactionIconsNetworkRepositoryImpl()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getReactIcons() -> AnyPublisher<[ReactIcon], Error> {
        api.request(
            target: ReactionIconsTargets.GetReactIcons(),
            atKeyPath: "data"
        )
    }
}
