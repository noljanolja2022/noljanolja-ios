//
//  Int+Format.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import Foundation

extension Int {
    func formatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."

        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number)!
        return formattedValue
    }

    func signFormatted() -> String {
        let signString = self > 0 ? "+" : ""
        return "\(signString) \(formatted())"
    }
}

extension Int {
    func relativeFormatted(maximumFractionDigits: Int = 1) -> String {
        let double = Swift.abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch double {
        case 1_000_000_000...:
            let resultDouble = double / 1_000_000_000
            let result = resultDouble.formatted(maximumFractionDigits: maximumFractionDigits)
            return "\(sign)\(result)B"
        case 1_000_000...:
            let resultDouble = double / 1_000_000
            let result = resultDouble.formatted(maximumFractionDigits: maximumFractionDigits)
            return "\(sign)\(result)B"
        case 1_000...:
            let resultDouble = double / 1_000
            let result = resultDouble.formatted(maximumFractionDigits: maximumFractionDigits)
            return "\(sign)\(result)B"
        case 0...:
            return "\(self)"
        default:
            return "\(sign)\(self)"
        }
    }
}

extension Double {
    func formatted(maximumFractionDigits: Int = 1, minimumFractionDigits: Int = 1) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits

        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number)!
        return formattedValue
    }
}
