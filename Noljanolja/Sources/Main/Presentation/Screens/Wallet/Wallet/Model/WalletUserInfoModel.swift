//
//  WalletUserInfoModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/05/2023.
//

import Foundation

struct WalletUserInfoModel: Equatable {
    let avatar: String?
    let name: String?
    let tierModelType: LoyaltyTierModelType?
    let exchangeablePoints: Int?
    init(currentUser: User, memberInfo: LoyaltyMemberInfo) {
        self.avatar = currentUser.avatar
        self.name = currentUser.name
        self.tierModelType = LoyaltyTierModelType(tier: memberInfo.currentTier)
        self.exchangeablePoints = memberInfo.exchangeablePoints
    }
}
