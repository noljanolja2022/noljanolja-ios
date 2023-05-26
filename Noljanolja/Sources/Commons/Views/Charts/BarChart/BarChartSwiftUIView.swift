//
//  BarChatView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/05/2023.
//

import Charts
import Foundation
import SwiftUI

// MARK: - BarChartSwiftUIView

struct BarChartSwiftUIView: UIViewRepresentable {
    private let data: BarChartData
    private let config: BarChartConfig
    private let legend: LegendConfig
    private let xAxis: XAxisConfig
    private let leftAxis: YAxisConfig
    private let rightAxis: YAxisConfig

    init(data: BarChartData,
         config: BarChartConfig = BarChartConfig(),
         legend: LegendConfig = LegendConfig(),
         xAxis: XAxisConfig = XAxisConfig(),
         leftAxis: YAxisConfig = YAxisConfig(),
         rightAxis: YAxisConfig = YAxisConfig()) {
        self.data = data
        self.config = config
        self.legend = legend
        self.xAxis = xAxis
        self.leftAxis = leftAxis
        self.rightAxis = rightAxis
    }

    func makeUIView(context: Context) -> BarChartView {
        let uiView = BarChartView()
        return uiView
    }

    func updateUIView(_ uiView: BarChartView, context: Context) {
        context.coordinator.base = self

        uiView.data = data
        uiView.setConfig(config)
        uiView.legend.setConfig(legend)
        uiView.xAxis.setConfig(xAxis)
        uiView.leftAxis.setConfig(leftAxis)
        uiView.rightAxis.setConfig(rightAxis)
    }

    func makeCoordinator() -> Coordinator {
        .init(base: self)
    }

    class Coordinator: NSObject {
        var base: BarChartSwiftUIView

        init(base: BarChartSwiftUIView) {
            self.base = base
        }
    }
}
