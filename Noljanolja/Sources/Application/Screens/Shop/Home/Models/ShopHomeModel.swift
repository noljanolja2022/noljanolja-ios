//
//  ShopHomeData.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/06/2023.
//

import Foundation

struct ShopHomeModel {
    let memberInfo: LoyaltyMemberInfo?
    let myCoupons: [MyCoupon]
    let shopCoupons: [Coupon]

    var isEmpty: Bool {
        memberInfo == nil
            && myCoupons.isEmpty
            && shopCoupons.isEmpty
    }

    init(memberInfo: LoyaltyMemberInfo? = nil,
         myCoupons: [MyCoupon] = [],
         shopCoupons: [Coupon] = []) {
        self.memberInfo = memberInfo
        self.myCoupons = myCoupons
        self.shopCoupons = shopCoupons
    }
}
