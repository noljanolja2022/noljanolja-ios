//
//  WalletModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/05/2023.
//

import Foundation

struct WalletModel {
    let userInfo: WalletUserInfoModel
    let point: Int

    init(currentUser: User, memberInfo: LoyaltyMemberInfo) {
        self.userInfo = WalletUserInfoModel(currentUser: currentUser, memberInfo: memberInfo)
        self.point = memberInfo.point
    }
}
