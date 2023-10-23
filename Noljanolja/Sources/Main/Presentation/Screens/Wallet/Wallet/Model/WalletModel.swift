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
    let coin: Double
    let accumulatedPointsToday: Int
    let exchangeablePoints: Int
    let checkinProgresses: [CheckinProgress]

    init(currentUser: User, memberInfo: LoyaltyMemberInfo, coinModel: CoinModel, checkinProgresses: [CheckinProgress]) {
        self.userInfo = WalletUserInfoModel(currentUser: currentUser, memberInfo: memberInfo)
        self.point = memberInfo.point
        self.coin = coinModel.balance
        self.accumulatedPointsToday = memberInfo.accumulatedPointsToday
        self.exchangeablePoints = memberInfo.exchangeablePoints
        self.checkinProgresses = checkinProgresses
    }
}
