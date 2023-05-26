//
//  TransactionHistoryHeaderModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/05/2023.
//

import Foundation

struct TransactionHistoryHeaderModel: Equatable {
    let dateTime: Date

    var displayDateTime: String {
        dateTime.string(withFormat: "MMMM yyyy")
    }

    init(dateTime: Date) {
        self.dateTime = dateTime
    }
}
