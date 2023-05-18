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

    struct GetTransactionHistory: BaseAuthTargetType {
        var path: String { "v1/loyalty/points" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        let filterType: TransactionFilterType
        let lastOffsetDate: Date?

        var parameters: [String: Any] {
            [
                "filterType": filterType.rawValue,
                "lastOffsetDate": lastOffsetDate?.string(withFormat: "dd/MM/yyyy")
            ]
            .compactMapValues { $0 }
        }

        var sampleData: Data {
            let json: [String: Any] = [
                "code": 0,
                "message": "string",
                "data": [
                    [
                        "id": "0",
                        "reason": "Received: Video watching",
                        "amount": -1000,
                        "createdAt": "2023-03-11T15:12:35Z"
                    ],
                    [
                        "id": "1",
                        "reason": "Received: Video watching",
                        "amount": 300,
                        "createdAt": "2023-03-11T21:12:35Z"
                    ],
                    [
                        "id": "2",
                        "reason": "Received: Aaaaaaaaaa",
                        "amount": 12314,
                        "createdAt": "2023-03-12T15:12:35Z"
                    ],
                    [
                        "id": "3",
                        "reason": "Received: Video watching",
                        "amount": 019,
                        "createdAt": "2023-04-13T15:12:35Z"
                    ],
                    [
                        "id": "4",
                        "reason": "Received: Bbbbbbbbbbbbb",
                        "amount": -20,
                        "createdAt": "2023-04-13T09:12:35Z"
                    ],
                    [
                        "id": "5",
                        "reason": "Received: Video watching",
                        "amount": -1239821,
                        "createdAt": "2023-03-13T21:12:35Z"
                    ],
                    [
                        "id": "6",
                        "reason": "Received: Video watching",
                        "amount": 191,
                        "createdAt": "2023-03-13T10:12:35Z"
                    ],
                    [
                        "id": "7",
                        "reason": "Received: Video watching",
                        "amount": -3,
                        "createdAt": "2023-05-15T15:12:35Z"
                    ]
                ]
            ]
            let data = json.jsonData()
            return data ?? Data()
        }
    }
}

// MARK: - LoyaltyAPIType

protocol LoyaltyAPIType {
    func getLoyaltyMemberInfo() -> AnyPublisher<LoyaltyMemberInfo, Error>
    func getTransactionHistory(filterType: TransactionFilterType, lastOffsetDate: Date?) -> AnyPublisher<[Transaction], Error>
}

// MARK: - LoyaltyAPI

final class LoyaltyAPI: LoyaltyAPIType {
    static let `default` = LoyaltyAPI()

    private let api: ApiType
    private let stubAPI = Api(provider: ApiProvider(stubClosure: MoyaProvider.delayedStub(1))) // TODO: Remove

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getLoyaltyMemberInfo() -> AnyPublisher<LoyaltyMemberInfo, Error> {
        api.request(
            target: LoyaltyAPITargets.GetLoyaltyMemberInfo(),
            atKeyPath: "data"
        )
    }

    func getTransactionHistory(filterType: TransactionFilterType,
                               lastOffsetDate: Date?) -> AnyPublisher<[Transaction], Error> {
//        api
        stubAPI
            .request(
                target: LoyaltyAPITargets.GetTransactionHistory(
                    filterType: filterType,
                    lastOffsetDate: lastOffsetDate
                ),
                atKeyPath: "data"
            )
    }
}
