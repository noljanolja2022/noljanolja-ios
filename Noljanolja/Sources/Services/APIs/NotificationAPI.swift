//
//  NotificationAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/03/2023.
//

import Combine
import Foundation
import Moya

// MARK: - NotificationAPITargets

private enum NotificationAPITargets {
    struct SendPushToken: BaseAuthTargetType {
        var path: String { "v1/push-token" }
        var method: Moya.Method { .post }
        var task: Task {
            .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }

        var parameters: [String: Any] {
            [
                "userId": "string",
                "deviceToken": "string",
                "deviceType": "iOS"
            ]
        }

        let userId: String
        let deviceToken: String
    }
}

// MARK: - NotificationAPIType

protocol NotificationAPIType {
    func sendPushToken(userId: String, deviceToken: String) -> AnyPublisher<Void, Error>
}

// MARK: - NotificationAPI

final class NotificationAPI: NotificationAPIType {
    static let `default` = NotificationAPI()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func sendPushToken(userId: String, deviceToken: String) -> AnyPublisher<Void, Error> {
        api.request(
            target: NotificationAPITargets.SendPushToken(
                userId: userId,
                deviceToken: deviceToken
            )
        )
    }
}
