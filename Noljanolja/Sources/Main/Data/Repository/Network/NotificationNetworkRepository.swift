//
//  NotificationNetworkRepositoryImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/03/2023.
//

import Combine
import Foundation
import Moya

// MARK: - NotificationTargets

private enum NotificationTargets {
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

    struct GetNotifications: BaseAuthTargetType {
        var path: String { "v1/notification" }
        var method: Moya.Method { .get }
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.queryString) }

        let page: Int
        let pageSize: Int

        var parameters: [String: Any] {
            [
                "page": page,
                "pageSize": pageSize
            ]
        }
    }
}

// MARK: - NotificationNetworkRepository

protocol NotificationNetworkRepository {
    func sendPushToken(deviceToken: String) -> AnyPublisher<Void, Error>
    func getNotificaionts(page: Int, pageSize: Int) -> AnyPublisher<[NotificationsModel], Error>
}

// MARK: - NotificationNetworkRepositoryImpl

final class NotificationNetworkRepositoryImpl: NotificationNetworkRepository {
    static let shared = NotificationNetworkRepositoryImpl()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func sendPushToken(deviceToken: String) -> AnyPublisher<Void, Error> {
        api.request(
            target: NotificationTargets.SendPushToken(
                deviceToken: deviceToken
            )
        )
    }

    func getNotificaionts(page: Int, pageSize: Int) -> AnyPublisher<[NotificationsModel], Error> {
        api.request(
            target:
            NotificationTargets.GetNotifications(
                page: page,
                pageSize: pageSize
            ),
            atKeyPath: "data"
        )
    }
}
