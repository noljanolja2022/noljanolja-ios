//
//  MyRankingModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/05/2023.
//

import Foundation

struct MyRankingModel {
    let currentTierModelType: LoyaltyTierModelType?
    let nextTierModelType: LoyaltyTierModelType?
    let tierModelTypes: [LoyaltyTierModelType]

    init(memberInfo: LoyaltyMemberInfo) {
        let currentTierModelType = LoyaltyTierModelType(tier: memberInfo.currentTier)
        self.currentTierModelType = currentTierModelType
        self.nextTierModelType = (currentTierModelType?.rawValue).flatMap { LoyaltyTierModelType(rawValue: $0 + 1) }
        self.tierModelTypes = [.bronze, .silver, .gold, .diamond]
    }
}
