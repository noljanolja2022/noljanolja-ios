//
//  ReferralPointsConfig.swift
//  Noljanolja
//
//  Created by kii on 11/01/2024.
//

import Foundation

struct ReferralPointsConfig: Equatable, Codable {
    let refereePoints: Int?
    let refererPoints: Int?
    let updatedAt: String?
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.refereePoints = try container.decode(Int.self, forKey: .refereePoints)
        self.refererPoints = try container.decodeIfPresent(Int.self, forKey: .refererPoints)
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}
