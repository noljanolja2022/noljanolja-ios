//
//  SearchGiftsModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//

import Foundation

struct SearchGiftsModel {
    let memberInfo: LoyaltyMemberInfo?
    let giftsResponse: PaginationResponse<[Gift]>

    var isEmpty: Bool {
        giftsResponse.data.isEmpty
    }
}
