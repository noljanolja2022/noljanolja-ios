//
//  CoinExchangeRate.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/10/2023.
//

import Foundation

struct CoinExchangeRate: Equatable, Codable {
    let point: Double?
    let coin: Double?
    let rewardRecurringAmount: Int?

    enum CodingKeys: String, CodingKey {
        case point
        case coin
        case rewardRecurringAmount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.point = try container.decodeIfPresent(Double.self, forKey: .point)
        self.coin = try container.decodeIfPresent(Double.self, forKey: .coin)
        self.rewardRecurringAmount = try container.decodeIfPresent(Int.self, forKey: .rewardRecurringAmount)
    }
}
