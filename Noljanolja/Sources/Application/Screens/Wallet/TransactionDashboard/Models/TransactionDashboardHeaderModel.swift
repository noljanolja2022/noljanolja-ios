//
//  TransactionDashboardHeaderModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/05/2023.
//

import Foundation

struct TransactionDashboardHeaderModel: Equatable {
    private let dateTime: Date
    let weekday: String
    let date: String

    init(dateTime: Date) {
        self.dateTime = dateTime
        self.weekday = dateTime.string(withFormat: "EEEE")
        self.date = dateTime.string(withFormat: "MMMM dd, yyyy")
    }
}
