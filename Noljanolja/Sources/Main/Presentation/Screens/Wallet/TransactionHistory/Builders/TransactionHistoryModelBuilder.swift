//
//  TransactionHistoryItemBuilder.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 17/05/2023.
//

import Foundation

struct TransactionHistoryModelBuilder {
    private let models: [Transaction]

    init(models: [Transaction]) {
        self.models = models
    }

    func build() -> TransactionHistoryModel {
        var modelsList = [[Transaction]]()
        let sortedModels = models.sorted(by: { $0.createdAt < $1.createdAt })
        sortedModels.forEach { currentModel in
            let firstIndex = modelsList.firstIndex { models in
                models.contains { model in
                    Calendar.current.isDate(currentModel.createdAt, equalTo: model.createdAt, toGranularity: .month)
                }
            }
            if let firstIndex {
                modelsList[firstIndex].append(currentModel)
            } else {
                modelsList.append([currentModel])
            }
        }

        let sectionModels = modelsList.map { models in
            TransactionHistorySectionModel(
                header: TransactionHistoryHeaderModel(dateTime: models[0].createdAt),
                items: models.map { TransactionHistoryItemModel(model: $0) }
            )
        }
        return TransactionHistoryModel(sections: sectionModels)
    }
}
