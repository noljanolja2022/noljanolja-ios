//
//  BarChatView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/05/2023.
//

import Charts
import Foundation
import SwiftUI

// MARK: - BarChartConfig

struct BarChartConfig {
    let isScaleEnabled: Bool

    init(isScaleEnabled: Bool = true) {
        self.isScaleEnabled = isScaleEnabled
    }
}

// MARK: - BarChartSwiftUIView

struct BarChartSwiftUIView: UIViewRepresentable {
    private let config: BarChartConfig
    private let data: BarChartData

    init(config: BarChartConfig = BarChartConfig(),
         data: BarChartData) {
        self.config = config
        self.data = data
    }

    func makeUIView(context: Context) -> BarChartView {
        let uiView = BarChartView()
        return uiView
    }

    func updateUIView(_ uiView: BarChartView, context: Context) {
        context.coordinator.base = self

        updateUIView(uiView)
    }

    func makeCoordinator() -> Coordinator {
        .init(base: self)
    }

    private func updateUIView(_ uiView: BarChartView) {
        uiView.setScaleEnabled(config.isScaleEnabled)

        let groupSpace = 0.54
        let barSpace = 0.03
        let barWidth = 0.2
        // (0.2 + 0.03) * 4 + 0.08 = 1.00 -> interval per "group"

//        let set1 = BarChartDataSet(
//            entries: [
//                BarChartDataEntry(x: 0, y: 10),
//                BarChartDataEntry(x: 1, y: 30),
//                BarChartDataEntry(x: 2, y: 20),
//                BarChartDataEntry(x: 3, y: 40)
//            ],
//            label: "Charge"
//        )
//        set1.setColor(.green)
//
//        let set2 = BarChartDataSet(
//            entries: [
//                BarChartDataEntry(x: 0, y: 10),
//                BarChartDataEntry(x: 1, y: 30),
//                BarChartDataEntry(x: 2, y: 20),
//                BarChartDataEntry(x: 3, y: 40)
//            ],
//            label: "Discharge"
//        )
//        set2.setColor(.red)
//
//        let data: BarChartData = [set1, set2]
//        data.setValueFont(.systemFont(ofSize: 10, weight: .light))

        // specify the width each bar should have
        data.barWidth = barWidth

        // restrict the x-axis range
        uiView.xAxis.axisMinimum = Double(0)

        // groupWidthWithGroupSpace(...) is a helper that calculates the width each group needs based on the provided parameters
        uiView.xAxis.axisMaximum = 0 + data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(4)

        data.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)

        uiView.data = data
    }

    class Coordinator: NSObject {
        var base: BarChartSwiftUIView

        init(base: BarChartSwiftUIView) {
            self.base = base
        }
    }
}
