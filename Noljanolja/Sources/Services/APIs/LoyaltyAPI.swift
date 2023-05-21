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
        var path: String { "v1/loyalty/me/points" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        let lastOffsetDate: Date?
        let type: TransactionType
        let monthYearDate: Date?

        var parameters: [String: Any] {
            [
                "lastOffsetDate": lastOffsetDate?.string(withFormat: "dd/MM/yyyy"),
                "type": type.rawValue,
                "monht": monthYearDate.flatMap {
                    Calendar.current.dateComponents([.month], from: $0)
                },
                "year": monthYearDate.flatMap {
                    Calendar.current.dateComponents([.year], from: $0)
                }
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
                        "reason": "Test 0",
                        "amount": 1000,
                        "createdAt": "2023-03-01T15:12:35Z"
                    ],
                    [
                        "id": "1",
                        "reason": "Received: Video watching",
                        "amount": 300,
                        "createdAt": "2023-03-05T21:12:35Z"
                    ],
                    [
                        "id": "2",
                        "reason": "Buy item",
                        "amount": -1500,
                        "createdAt": "2023-03-11T15:12:35Z"
                    ],
                    [
                        "id": "3",
                        "reason": "Charge",
                        "amount": 300,
                        "createdAt": "2023-03-07T21:12:35Z"
                    ],
                    [
                        "id": "4",
                        "reason": "Received: Video watching",
                        "amount": -800,
                        "createdAt": "2023-03-11T15:12:35Z"
                    ],
                    [
                        "id": "5",
                        "reason": "Received: Video watching",
                        "amount": 300,
                        "createdAt": "2023-03-11T21:12:35Z"
                    ],
                    [
                        "id": "6",
                        "reason": "Received: Aaaaaaaaaa",
                        "amount": 400,
                        "createdAt": "2023-03-12T15:12:35Z"
                    ],
                    [
                        "id": "7",
                        "reason": "Received: Video watching",
                        "amount": -500,
                        "createdAt": "2023-03-13T15:12:35Z"
                    ],
                    [
                        "id": "8",
                        "reason": "Received: Bbbbbbbbbbbbb",
                        "amount": -20,
                        "createdAt": "2023-03-14T09:12:35Z"
                    ],
                    [
                        "id": "9",
                        "reason": "Received: Video watching",
                        "amount": -821,
                        "createdAt": "2023-03-16T21:12:35Z"
                    ],
                    [
                        "id": "10",
                        "reason": "Received: Video watching",
                        "amount": 191,
                        "createdAt": "2023-03-17T10:12:35Z"
                    ],
                    [
                        "id": "11",
                        "reason": "Received: Video watching",
                        "amount": -30,
                        "createdAt": "2023-03-20T15:12:35Z"
                    ],
                    [
                        "id": "12",
                        "reason": "Received: Bbbbbbbbbbbbb",
                        "amount": -20,
                        "createdAt": "2023-04-21T09:12:35Z"
                    ],
                    [
                        "id": "13",
                        "reason": "Received: Video watching",
                        "amount": -821,
                        "createdAt": "2023-03-24T21:12:35Z"
                    ],
                    [
                        "id": "14",
                        "reason": "Received: Video watching",
                        "amount": 191,
                        "createdAt": "2023-03-25T10:12:35Z"
                    ],
                    [
                        "id": "15",
                        "reason": "Received: Video watching",
                        "amount": -30,
                        "createdAt": "2023-03-30T15:12:35Z"
                    ],
                    [
                        "id": "16",
                        "reason": "Received: Bbbbbbbbbbbbb",
                        "amount": -20,
                        "createdAt": "2023-05-21T09:12:35Z"
                    ],
                    [
                        "id": "17",
                        "reason": "Received: Video watching",
                        "amount": -821,
                        "createdAt": "2023-05-24T21:12:35Z"
                    ],
                    [
                        "id": "18",
                        "reason": "Received: Video watching",
                        "amount": 191,
                        "createdAt": "2023-05-25T10:12:35Z"
                    ],
                    [
                        "id": "19",
                        "reason": "Received: Video watching",
                        "amount": -30,
                        "createdAt": "2023-06-30T15:12:35Z"
                    ],
                    [
                        "id": "20",
                        "reason": "Received: Video watching",
                        "amount": -30,
                        "createdAt": "2023-06-30T15:12:35Z"
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
    func getTransactionHistory(lastOffsetDate: Date?,
                               type: TransactionType,
                               monthYearDate: Date?) -> AnyPublisher<[Transaction], Error>
}

extension LoyaltyAPIType {
    func getTransactionHistory(lastOffsetDate: Date? = nil,
                               type: TransactionType = .all,
                               monthYearDate: Date? = nil) -> AnyPublisher<[Transaction], Error> {
        getTransactionHistory(
            lastOffsetDate: lastOffsetDate,
            type: type,
            monthYearDate: monthYearDate
        )
    }
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

    func getTransactionHistory(lastOffsetDate: Date?,
                               type: TransactionType,
                               monthYearDate: Date?) -> AnyPublisher<[Transaction], Error> {
//        api
        stubAPI
            .request(
                target: LoyaltyAPITargets.GetTransactionHistory(
                    lastOffsetDate: lastOffsetDate,
                    type: type,
                    monthYearDate: monthYearDate
                ),
                atKeyPath: "data"
            )
    }
}
