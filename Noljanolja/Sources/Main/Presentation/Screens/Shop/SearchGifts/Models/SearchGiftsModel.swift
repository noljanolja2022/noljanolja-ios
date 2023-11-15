//
//  SearchGiftsModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//

import Foundation

struct SearchGiftsModel {
    let coinModel: CoinModel?
    let myGiftString: String?
    let giftsResponse: PaginationResponse<[Gift]>

    var isEmpty: Bool {
        coinModel == nil
            && myGiftString == nil
            && giftsResponse.data.isEmpty
    }
}
