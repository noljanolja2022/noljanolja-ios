//
//  ShopHomeData.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/06/2023.
//

import Foundation

struct ShopHomeModel {
    let coinModel: CoinModel?
    let myGiftString: String?

    var isEmpty: Bool {
        coinModel == nil && myGiftString == nil
    }

    init(coinModel: CoinModel? = nil, myGiftString: String? = nil) {
        self.coinModel = coinModel
        self.myGiftString = myGiftString
    }
}
