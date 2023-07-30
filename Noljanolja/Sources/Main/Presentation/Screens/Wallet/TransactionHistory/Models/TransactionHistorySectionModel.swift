//
//  TransactionHistorySectionModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/05/2023.
//

import Foundation

// MARK: - TransactionHistorySectionModel

struct TransactionHistorySectionModel: Equatable {
    let header: TransactionHistoryHeaderModel
    let items: [TransactionHistoryItemModel]
}
