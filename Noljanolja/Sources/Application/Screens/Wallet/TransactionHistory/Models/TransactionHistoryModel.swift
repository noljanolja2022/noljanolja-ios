//
//  TransactionHistoryModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 17/05/2023.
//

import Foundation

// MARK: - TransactionHistoryModel

struct TransactionHistoryModel: Equatable {
    let sections: [TransactionHistorySectionModel]
}

// MARK: - TransactionHistorySectionModel

struct TransactionHistorySectionModel: Equatable {
    let header: TransactionHistoryHeaderModel
    let items: [TransactionHistoryItemModel]
}
