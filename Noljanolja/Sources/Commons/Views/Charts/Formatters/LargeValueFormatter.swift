//
//  LargeValueFormatter.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/05/2023.
//

import Charts
import Foundation

// MARK: - LargeValueFormatter

final class LargeValueFormatter: NSObject, ValueFormatter, AxisValueFormatter {
    /// Suffix to be appended after the values.
    ///
    /// **default**: suffix: ["", "k", "m", "b", "t"]
    public var suffix = ["", "k", "m", "b", "t"]

    /// An appendix text to be added at the end of the formatted value.
    public var appendix: String?

    public init(appendix: String? = nil) {
        self.appendix = appendix
    }

    private func format(value: Double) -> String {
        var sig = value
        var length = 0
        let maxLength = suffix.count - 1

        while sig >= 1000.0, length < maxLength {
            sig /= 1000.0
            length += 1
        }

        var r = String(format: "%2.f", sig) + suffix[length]

        if let appendix {
            r += appendix
        }

        return r
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        format(value: value)
    }

    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        format(value: value)
    }
}
