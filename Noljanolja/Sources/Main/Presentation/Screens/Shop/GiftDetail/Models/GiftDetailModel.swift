//
//  GiftDetailModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/06/2023.
//

import Foundation
import UIKit

struct GiftDetailModel {
    let giftDetailInputType: GiftDetailInputType
    let giftBrandName: String?
    let giftName: String?
    let giftDescription: String?
    let giftImage: String?
    let giftCode: String?
    let giftCodeQRImage: UIImage?
    let giftPrice: Double
    let myCoin: Double
    let remainingCoin: Double
    let isPurchasable: Bool

    init(coinModel: CoinModel,
         giftDetailInputType: GiftDetailInputType) {
        self.giftDetailInputType = giftDetailInputType
        switch giftDetailInputType {
        case let .gift(gift):
            self.giftBrandName = gift.brand?.name
            self.giftName = gift.name
            self.giftDescription = gift.description
            self.giftImage = gift.image
            self.giftPrice = gift.price
            self.giftCode = nil
            self.giftCodeQRImage = nil
            self.isPurchasable = true
        case let .myGift(myGift):
            self.giftBrandName = myGift.brand?.name
            self.giftName = myGift.name
            self.giftDescription = myGift.description
            self.giftImage = myGift.qrCode
            self.giftPrice = 0
            self.giftCode = myGift.qrCode
            self.giftCodeQRImage = nil // myGift.qrCode.qrCodeImage()
            self.isPurchasable = false
        }

        self.myCoin = coinModel.balance
        self.remainingCoin = myCoin - giftPrice
    }
}
