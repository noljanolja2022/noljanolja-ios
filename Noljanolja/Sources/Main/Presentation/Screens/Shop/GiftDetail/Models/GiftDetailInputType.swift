//
//  GiftDetailInputType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/06/2023.
//

import Foundation

enum GiftDetailInputType {
    case gift(Gift)
    case myGift(MyGift)

    var gift: Gift? {
        switch self {
        case let .gift(gift): return gift
        case .myGift: return nil
        }
    }
}
