//
//  Chart+Config.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/05/2023.
//

import Charts
import Foundation

// MARK: - BarLineChartBaseConfig

class BarLineChartBaseConfig {
    var isScaleEnabled: Bool?
}

// MARK: - BarChartConfig

class BarChartConfig: BarLineChartBaseConfig {}

extension BarLineChartViewBase {
    func setConfig(_ config: BarLineChartBaseConfig) {
        if let isScaleEnabled = config.isScaleEnabled {
            setScaleEnabled(isScaleEnabled)
        }
    }
}

extension BarChartView {
    func setConfig(_ config: BarChartConfig) {
        super.setConfig(config)
    }
}
