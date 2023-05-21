//
//  TransactionDashboardModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/05/2023.
//

import Charts
import Foundation

struct TransactionDashboardModel: Equatable {
    let title: String
    let barChartData: BarChartData
    let sections: [TransactionDashboardSectionModel]
}
