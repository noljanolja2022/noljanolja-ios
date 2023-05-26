//
//  Axis+Config.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/05/2023.
//

import Charts
import Foundation
import UIKit

// MARK: - AxisBaseConfig

class AxisBaseConfig: ComponentBaseConfig {
    var axisMaximum: Double?
    var axisMinimum: Double?
    var centerAxisLabelsEnabled: Bool?
    var drawGridLinesEnabled: Bool?
    var labelFont: UIFont?
    var valueFormatter: AxisValueFormatter?
}

// MARK: - XAxisConfig

class XAxisConfig: AxisBaseConfig {
    var granularity: Double?
    var granularityEnabled: Bool?
    var labelPosition: XAxis.LabelPosition?
}

// MARK: - YAxisConfig

class YAxisConfig: AxisBaseConfig {
    var drawAxisLineEnabled: Bool?
    var drawLabelsEnabled: Bool?
    var drawBottomYLabelEntryEnabled: Bool?
}

extension AxisBase {
    func setConfig(_ config: AxisBaseConfig) {
        if let axisMaximum = config.axisMaximum {
            self.axisMaximum = axisMaximum
        }
        if let axisMinimum = config.axisMinimum {
            self.axisMinimum = axisMinimum
        }
        if let centerAxisLabelsEnabled = config.centerAxisLabelsEnabled {
            self.centerAxisLabelsEnabled = centerAxisLabelsEnabled
        }
        if let drawGridLinesEnabled = config.drawGridLinesEnabled {
            self.drawGridLinesEnabled = drawGridLinesEnabled
        }
        if let labelFont = config.labelFont {
            self.labelFont = labelFont
        }
        if let valueFormatter = config.valueFormatter {
            self.valueFormatter = valueFormatter
        }
    }
}

extension XAxis {
    func setConfig(_ config: XAxisConfig) {
        if let granularity = config.granularity {
            self.granularity = granularity
        }
        if let granularityEnabled = config.granularityEnabled {
            self.granularityEnabled = granularityEnabled
        }
        if let labelPosition = config.labelPosition {
            self.labelPosition = labelPosition
        }

        super.setConfig(config)
    }
}

extension YAxis {
    func setConfig(_ config: YAxisConfig) {
        if let drawAxisLineEnabled = config.drawAxisLineEnabled {
            self.drawAxisLineEnabled = drawAxisLineEnabled
        }
        if let drawLabelsEnabled = config.drawLabelsEnabled {
            self.drawLabelsEnabled = drawLabelsEnabled
        }
        if let drawBottomYLabelEntryEnabled = config.drawBottomYLabelEntryEnabled {
            self.drawBottomYLabelEntryEnabled = drawBottomYLabelEntryEnabled
        }

        super.setConfig(config)
    }
}
