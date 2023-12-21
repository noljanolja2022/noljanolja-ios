//
//  TransactionHistoryItemModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/05/2023.
//

import Foundation

struct TransactionHistoryItemModel: Equatable {
    let id: Int
    let title: String
    let dateTime: String
    let point: String
    let pointColor: String

    init(model: Transaction) {
        self.id = model.id
        self.title = "\(model.type.title): \(model.reason ?? "")"
        self.dateTime = model.createdAt.string(withFormat: "HH:mm - yyyy/M/d")
        self.point = L10n.transactionHistoryPoint(model.amount.signFormatted())
        self.pointColor = model.amount > 0 ? ColorAssets.primaryGreen200.name : ColorAssets.systemRed100.name
    }
}
