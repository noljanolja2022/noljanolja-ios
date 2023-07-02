//
//  ReactionIconsRemoteRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/06/2023.
//

import Combine
import Foundation
import Moya
import UIKit

// MARK: - ReactionIconsRemoteTargets

private enum ReactionIconsRemoteTargets {
    struct GetReactIcons: BaseAuthTargetType {
        var path: String { "v1/conversations/react-icons" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }
    }
}

// MARK: - ReactionIconsRemoteRepositoryProtocol

protocol ReactionIconsRemoteRepositoryProtocol {
    func getReactIcons() -> AnyPublisher<[ReactIcon], Error>
}

// MARK: - ReactionIconsRemoteRepository

final class ReactionIconsRemoteRepository: ReactionIconsRemoteRepositoryProtocol {
    static let `default` = ReactionIconsRemoteRepository()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getReactIcons() -> AnyPublisher<[ReactIcon], Error> {
        api.request(
            target: ReactionIconsRemoteTargets.GetReactIcons(),
            atKeyPath: "data"
        )
    }
}
