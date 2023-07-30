//
//  TransactionDashboardSectionModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/05/2023.
//

import Foundation

struct TransactionDashboardSectionModel: Equatable {
    let header: TransactionDashboardHeaderModel
    let items: [TransactionDashboardItemModel]
}
