//
//  ShopHomeData.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/06/2023.
//

import Foundation

struct ShopHomeModel {
    let coinModel: CoinModel?

    var isEmpty: Bool {
        coinModel == nil
    }

    init(coinModel: CoinModel? = nil) {
        self.coinModel = coinModel
    }
}
