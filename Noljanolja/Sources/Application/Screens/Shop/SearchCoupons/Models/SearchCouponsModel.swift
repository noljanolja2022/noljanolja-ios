//
//  SearchCouponsModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//

import Foundation

struct SearchCouponsModel {
    let memberInfo: LoyaltyMemberInfo?
    let couponsResponse: PaginationResponse<[Coupon]>

    var isEmpty: Bool {
        couponsResponse.data.isEmpty
    }
}
