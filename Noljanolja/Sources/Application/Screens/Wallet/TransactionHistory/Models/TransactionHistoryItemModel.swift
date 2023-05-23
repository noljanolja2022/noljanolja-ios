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
        self.title = model.reason ?? ""
        self.dateTime = model.createdAt.string(withFormat: "HH:mm - MMMM dd, yyyy")
        self.point = {
            let signString = model.amount > 0 ? "+" : ""
            return "\(signString) \(model.amount.formatted()) Points"
        }()
        self.pointColor = model.amount > 0 ? ColorAssets.primaryGreen200.name : ColorAssets.systemRed100.name
    }
}
