//
//  NetworkNotificationRepositoryImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/03/2023.
//

import Combine
import Foundation
import Moya

// MARK: - NetworkNotificationTargets

private enum NetworkNotificationTargets {
    struct SendPushToken: BaseAuthTargetType {
        var path: String { "v1/push-tokens" }
        var method: Moya.Method { .post }
        var task: Task {
            .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }

        var parameters: [String: Any] {
            [
                "deviceToken": deviceToken,
                "deviceType": "MOBILE"
            ]
        }

        let deviceToken: String
    }
}

// MARK: - NetworkNotificationRepository

protocol NetworkNotificationRepository {
    func sendPushToken(deviceToken: String) -> AnyPublisher<Void, Error>
}

// MARK: - NetworkNotificationRepositoryImpl

final class NetworkNotificationRepositoryImpl: NetworkNotificationRepository {
    static let shared = NetworkNotificationRepositoryImpl()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func sendPushToken(deviceToken: String) -> AnyPublisher<Void, Error> {
        api.request(
            target: NetworkNotificationTargets.SendPushToken(
                deviceToken: deviceToken
            )
        )
    }
}
