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
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.queryString) }

        let lastOffsetDate: Date?
        let type: TransactionType
        let monthYearDate: Date?

        var parameters: [String: Any] {
            [
                "lastOffsetDate": lastOffsetDate?.iso8601String,
                "type": type.rawValue,
                "month": monthYearDate.flatMap {
                    Calendar.current.dateComponents([.month], from: $0)
                },
                "year": monthYearDate.flatMap {
                    Calendar.current.dateComponents([.year], from: $0)
                }
            ]
            .compactMapValues { $0 }
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
        api
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
