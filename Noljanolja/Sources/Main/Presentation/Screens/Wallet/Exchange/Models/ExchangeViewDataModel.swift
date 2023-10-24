//
//  ExchangeModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/10/2023.
//

import Foundation

struct ExchangeViewDataModel {
    let point: Int
    let coin: Double
    let exchangeRate: Int?

    init(memberInfo: LoyaltyMemberInfo, coinModel: CoinModel, coinExchangeRate: CoinExchangeRate) {
        self.point = memberInfo.point
        self.coin = coinModel.balance
        self.exchangeRate = coinExchangeRate.coinToPointRate
    }
}
