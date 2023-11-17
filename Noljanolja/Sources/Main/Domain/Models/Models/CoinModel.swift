//
//  CoinModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 18/10/2023.
//

import Foundation

struct CoinModel: Equatable, Codable {
    let balance: Double
    let giftCount: Int

    enum CodingKeys: String, CodingKey {
        case balance
        case giftCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.balance = try container.decodeIfPresent(Double.self, forKey: .balance) ?? 0
        self.giftCount = try container.decodeIfPresent(Int.self, forKey: .giftCount) ?? 0
    }
}
