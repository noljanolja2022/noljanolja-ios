//
//  TransactionDashboardItemModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/05/2023.
//

import Foundation

struct TransactionDashboardItemModel: Equatable {
    let id: String
    let title: String
    let point: String
    let pointColor: String

    init(model: Transaction) {
        self.id = model.id
        self.title = model.reason ?? ""
        self.point = {
            let signString = model.amount > 0 ? "+" : ""
            return "\(signString) \(model.amount.formatted()) Points"
        }()
        self.pointColor = model.amount > 0 ? ColorAssets.primaryGreen200.name : ColorAssets.systemRed100.name
    }
}
