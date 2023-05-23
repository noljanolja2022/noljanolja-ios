//
//  MemberInfor.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/05/2023.
//

import Foundation

// MARK: - LoyaltyTierType

enum LoyaltyTierType: String {
    case bronze = "BRONZE"
    case silver = "SILVER"
    case gold = "GOLD"
    case diamond = "DIAMOND"
    case unknown
}

// MARK: - LoyaltyMemberInfo

struct LoyaltyMemberInfo: Equatable, Decodable {
    let memberId: String
    let point: Int
    let accumulatedPointsToday: Int
    let exchangeablePoints: Int
    let currentTier: LoyaltyTierType
    let currentTierMinPoint: Int
    let nextTier: LoyaltyTierType
    let nextTierMinPoint: Int

    enum CodingKeys: String, CodingKey {
        case memberId
        case point
        case accumulatedPointsToday
        case exchangeablePoints
        case currentTier
        case currentTierMinPoint
        case nextTier
        case nextTierMinPoint
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.memberId = try container.decode(String.self, forKey: .memberId)
        self.point = try container.decodeIfPresent(Int.self, forKey: .point) ?? 0
        self.accumulatedPointsToday = try container.decodeIfPresent(Int.self, forKey: .accumulatedPointsToday) ?? 0
        self.exchangeablePoints = try container.decodeIfPresent(Int.self, forKey: .exchangeablePoints) ?? 0
        self.currentTier = try {
            let string = try container.decode(String.self, forKey: .currentTier)
            return LoyaltyTierType(rawValue: string) ?? .unknown
        }()
        self.currentTierMinPoint = try container.decode(Int.self, forKey: .currentTierMinPoint)
        self.nextTier = try {
            let string = try container.decode(String.self, forKey: .nextTier)
            return LoyaltyTierType(rawValue: string) ?? .unknown
        }()
        self.nextTierMinPoint = try container.decode(Int.self, forKey: .nextTierMinPoint)
    }
}
