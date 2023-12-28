//
//  Transaction.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 17/05/2023.
//

import Foundation

struct Transaction: Equatable, Decodable {
    let id: Int
    let reason: String?
    let amount: Int
    let status: TransactionStatusType
    let createdAt: Date
    let type: TransactionType
    let reasonLocale: String?
    let unit: String?
    let log: String?

    enum CodingKeys: String, CodingKey {
        case id
        case reason
        case amount
        case status
        case createdAt
        case type
        case reasonLocale
        case unit
        case log
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.amount = try container.decode(Int.self, forKey: .amount)
        self.status = try container.decodeIfPresent(TransactionStatusType.self, forKey: .status) ?? .unknown
        self.type = try container.decodeIfPresent(TransactionType.self, forKey: .type) ?? .all
        if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt),
           let createdAt = createdAtString.date(withFormats: NetworkConfigs.Format.apiFullDateFormats) {
            self.createdAt = createdAt
        } else {
            throw DecodingError.valueNotFound(
                String.self,
                DecodingError.Context(
                    codingPath: container.codingPath + [CodingKeys.createdAt],
                    debugDescription: ""
                )
            )
        }
        self.reasonLocale = try container.decode(String.self, forKey: .reasonLocale)
        self.unit = try container.decode(String.self, forKey: .unit)
        self.log = try container.decodeIfPresent(String.self, forKey: .log)
    }
}
