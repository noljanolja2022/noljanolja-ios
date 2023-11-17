//
//  SearchGiftsModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//

import Foundation

struct SearchGiftsModel {
    let coinModel: CoinModel?
    let giftsResponse: PaginationResponse<[Gift]>

    var isEmpty: Bool {
        coinModel == nil
            && giftsResponse.data.isEmpty
    }
}
