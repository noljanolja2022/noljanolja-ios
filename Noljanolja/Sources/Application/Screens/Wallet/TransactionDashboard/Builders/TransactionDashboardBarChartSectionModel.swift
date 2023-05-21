//
//  TransactionDashboardBarChartSectionModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/05/2023.
//

import Foundation

struct TransactionDashboardBarChartSectionModel {
    let minDate: Date
    let maxDate: Date
    var transactions: [Transaction]

    init?(minDate: Date?, maxDate: Date?, transactions: [Transaction] = []) {
        guard let minDate, let maxDate else {
            return nil
        }
        self.minDate = minDate
        self.maxDate = maxDate
        self.transactions = transactions
    }
}
