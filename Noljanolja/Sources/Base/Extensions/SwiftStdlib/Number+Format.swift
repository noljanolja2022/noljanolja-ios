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
        formatter.decimalSeparator = ","

        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number)!
        return formattedValue
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
    func formatted(maximumFractionDigits: Int = 1) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 1

        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number)!
        return formattedValue
    }
}
