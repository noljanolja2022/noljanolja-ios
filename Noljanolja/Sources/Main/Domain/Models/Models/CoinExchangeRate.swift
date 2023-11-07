//
//  CoinExchangeRate.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/10/2023.
//

import Foundation

struct CoinExchangeRate: Equatable, Codable {
    let coinToPointRate: Int?
    let rewardRecurringAmount: Int?

    enum CodingKeys: String, CodingKey {
        case coinToPointRate
        case rewardRecurringAmount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coinToPointRate = try container.decodeIfPresent(Int.self, forKey: .coinToPointRate)
        self.rewardRecurringAmount = try container.decodeIfPresent(Int.self, forKey: .rewardRecurringAmount)
    }
}
