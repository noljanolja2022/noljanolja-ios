//
//  TransactionDetailModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/05/2023.
//

import Foundation

struct TransactionDetailModel {
    let type: String
    let dateTime: String
    let point: String
    let pointColor: String
    let code: String

    init(model: Transaction) {
        self.type = model.amount > 0 ? L10n.transactionReceiveType : L10n.transactionSpentType
        self.point = {
            let signString = model.amount > 0 ? "+" : ""
            return L10n.transactionHistoryPoint("\(signString) \(model.amount.formatted())")
        }()
        self.pointColor = model.amount > 0 ? ColorAssets.primaryGreen200.name : ColorAssets.systemRed100.name
        self.dateTime = model.createdAt.string(withFormat: "HH:mm - MMMM dd, yyyy")
        self.code = String(model.id)
    }
}
