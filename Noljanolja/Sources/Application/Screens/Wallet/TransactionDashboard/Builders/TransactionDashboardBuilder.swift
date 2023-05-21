//
//  TransactionDashboardBuilder.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/05/2023.
//

import Charts
import Foundation

struct TransactionDashboardBuilder {
    private let monthYearDate: Date
    private let models: [Transaction]

    init(monthYearDate: Date, models: [Transaction]) {
        self.monthYearDate = monthYearDate
        self.models = models
    }

    func buildModel() -> TransactionDashboardModel {
        let barChartData = buildBarChartData()
        let sections = buildSections()
        return TransactionDashboardModel(
            title: monthYearDate.string(withFormat: "MMMM yyyy"),
            barChartData: barChartData,
            sections: sections
        )
    }

    private func buildBarChartData() -> BarChartData {
        let startMonthDate = Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.month, .year],
                from: monthYearDate
            )
        )

        var sections = [
            TransactionDashboardBarChartSectionModel(
                minDate: startMonthDate,
                maxDate: startMonthDate.flatMap {
                    Calendar.current.date(byAdding: .day, value: 7, to: $0)
                }
            ),
            TransactionDashboardBarChartSectionModel(
                minDate: startMonthDate.flatMap {
                    Calendar.current.date(byAdding: .day, value: 7, to: $0)
                },
                maxDate: startMonthDate.flatMap {
                    Calendar.current.date(byAdding: .day, value: 14, to: $0)
                }
            ),
            TransactionDashboardBarChartSectionModel(
                minDate: startMonthDate.flatMap {
                    Calendar.current.date(byAdding: .day, value: 14, to: $0)
                },
                maxDate: startMonthDate.flatMap {
                    Calendar.current.date(byAdding: .day, value: 21, to: $0)
                }
            ),
            TransactionDashboardBarChartSectionModel(
                minDate: startMonthDate.flatMap {
                    Calendar.current.date(byAdding: .day, value: 21, to: $0)
                },
                maxDate: startMonthDate
                    .flatMap {
                        Calendar.current.date(byAdding: .month, value: 1, to: $0)
                    }
            )
        ]
        .compactMap { $0 }

        models.forEach { model in
            sections.indices.forEach { index in
                let section = sections[index]
                if section.minDate <= model.createdAt, model.createdAt <= section.maxDate {
                    sections[index].transactions.append(model)
                }
            }
        }

        let chargeDataSet = BarChartDataSet(
            entries: sections.enumerated().map { index, section in
                let sum = section.transactions.reduce(0) { result, transaction -> Int in
                    if transaction.amount > 0 {
                        return result + transaction.amount
                    } else {
                        return result
                    }
                }
                return BarChartDataEntry(x: Double(index), y: Double(sum))
            }
        )
        chargeDataSet.label = "Charge"
        chargeDataSet.setColor(ColorAssets.systemGreen.color)

        let spentDataSet = BarChartDataSet(
            entries: sections.enumerated().map { index, section in
                let sum = section.transactions.reduce(0) { result, transaction -> Int in
                    if transaction.amount < 0 {
                        return result - transaction.amount
                    } else {
                        return result
                    }
                }
                return BarChartDataEntry(x: Double(index), y: Double(sum))
            }
        )
        spentDataSet.label = "Discharge"
        spentDataSet.setColor(ColorAssets.systemRed100.color)

        return BarChartData(dataSets: [chargeDataSet, spentDataSet])
    }

    private func buildSections() -> [TransactionDashboardSectionModel] {
        var modelsList = [[Transaction]]()
        let sortedModels = models.sorted(by: { $0.createdAt < $1.createdAt })
        sortedModels.forEach { currentModel in
            let firstIndex = modelsList.firstIndex { models in
                models.contains { model in
                    Calendar.current.isDate(currentModel.createdAt, equalTo: model.createdAt, toGranularity: .day)
                }
            }
            if let firstIndex {
                modelsList[firstIndex].append(currentModel)
            } else {
                modelsList.append([currentModel])
            }
        }

        let sectionModels = modelsList.map { models in
            TransactionDashboardSectionModel(
                header: TransactionDashboardHeaderModel(dateTime: models[0].createdAt),
                items: models.map { TransactionDashboardItemModel(model: $0) }
            )
        }

        return sectionModels
    }
}
