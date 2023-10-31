//
//  CoinExchangeResult.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/10/2023.
//

import Foundation

struct CoinExchangeResult: Equatable, Codable {
    let id: Int
    let balanceId: Int?
    let reason: String?
    let amount: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case balanceId
        case reason
        case amount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.balanceId = try container.decodeIfPresent(Int.self, forKey: .balanceId)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.amount = try container.decodeIfPresent(Double.self, forKey: .amount)
    }
}
