//
//  TransactionDashboardModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/05/2023.
//

import Charts
import Foundation

struct TransactionDashboardModel {
    let title: String
    let chartModel: TransactionDashboardChartModel
    let sections: [TransactionDashboardSectionModel]
}
