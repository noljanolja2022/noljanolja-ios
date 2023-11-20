//
//  ShopHomeNavigations.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/06/2023.
//

import Foundation

// MARK: - ShopHomeNavigationType

enum ShopHomeNavigationType {
    case search
    case myGifts
    case giftDetail(Gift)
    case myGiftDetail(MyGift)
    case listGiftCategory(GiftCategory)
}
