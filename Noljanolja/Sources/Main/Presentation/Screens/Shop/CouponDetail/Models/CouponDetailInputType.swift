//
//  CouponDetailInputType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/06/2023.
//

import Foundation

enum CouponDetailInputType {
    case coupon(Coupon)
    case myCoupon(MyCoupon)

    var coupon: Coupon? {
        switch self {
        case let .coupon(coupon): return coupon
        case .myCoupon: return nil
        }
    }
}
