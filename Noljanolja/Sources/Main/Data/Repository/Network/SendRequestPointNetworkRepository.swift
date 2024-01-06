//
//  SendRequestPointNetworkRepository.swift
//  Noljanolja
//
//  Created by duydinhv on 05/01/2024.
//

import Combine
import Foundation
import Moya

// MARK: - SendRequestTargets

private enum SendRequestTargets {
    struct SendPoint: BaseAuthTargetType {
        var path: String { "v1/transfer-point/send" }
        let method: Moya.Method = .post
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.queryString) }

        let points: Int
        let toUserId: String
        var parameters: [String: Any] {
            [
                "points": points,
                "toUserId": toUserId
            ]
        }
    }

    struct RequestPoint: BaseAuthTargetType {
        var path: String { "v1/transfer-point/request" }
        let method: Moya.Method = .post
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.queryString) }

        let points: Int
        let toUserId: String
        var parameters: [String: Any] {
            [
                "points": points,
                "toUserId": toUserId
            ]
        }
    }
}

// MARK: - SendRequestPointNetworkRepository

protocol SendRequestPointNetworkRepository {
    func sendPoints(_ points: Int, _ toUserId: String) -> AnyPublisher<SendRequestPointsModel, Error>
    func requestPoint(_ points: Int, _ toUserId: String) -> AnyPublisher<SendRequestPointsModel, Error>
}

// MARK: - SendRequestPointNetworkRepositoryImpl

final class SendRequestPointNetworkRepositoryImpl: SendRequestPointNetworkRepository {
    static let shared: SendRequestPointNetworkRepository = SendRequestPointNetworkRepositoryImpl()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func sendPoints(_ points: Int, _ toUserId: String) -> AnyPublisher<SendRequestPointsModel, Error> {
        api.request(
            target: SendRequestTargets.SendPoint(points: points, toUserId: toUserId),
            atKeyPath: "data"
        )
    }

    func requestPoint(_ points: Int, _ toUserId: String) -> AnyPublisher<SendRequestPointsModel, Error> {
        api.request(
            target: SendRequestTargets.RequestPoint(points: points, toUserId: toUserId),
            atKeyPath: "data"
        )
    }
}
