//
//  CouponDetailModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/06/2023.
//

import Foundation
import UIKit

struct CouponDetailModel {
    let couponDetailInputType: CouponDetailInputType
    let couponBrandName: String?
    let couponName: String?
    let couponImage: String?
    let couponCode: String?
    let couponCodeQRImage: UIImage?
    let couponPrice: Int
    let myPoint: Int
    let remainingPoint: Int
    let isPurchasable: Bool

    init(memberInfo: LoyaltyMemberInfo,
         couponDetailInputType: CouponDetailInputType) {
        self.couponDetailInputType = couponDetailInputType
        switch couponDetailInputType {
        case let .coupon(coupon):
            self.couponBrandName = coupon.brand?.name
            self.couponName = coupon.name
            self.couponImage = coupon.image
            self.couponPrice = coupon.price
            self.couponCode = nil
            self.couponCodeQRImage = nil
            self.isPurchasable = coupon.isPurchasable
        case let .myCoupon(myCoupon):
            self.couponBrandName = myCoupon.brand?.name
            self.couponName = myCoupon.name
            self.couponImage = myCoupon.image
            self.couponPrice = 0
            self.couponCode = myCoupon.code
            self.couponCodeQRImage = myCoupon.code.qrCodeImage()
            self.isPurchasable = false
        }

        self.myPoint = memberInfo.point
        self.remainingPoint = myPoint - couponPrice
    }
}
