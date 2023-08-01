//
//  String+Date.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/03/2023.
//

import Foundation

extension String {
    func date(timeZone: TimeZone? = .current, withFormats formats: [String]) -> Date? {
        formats
            .compactMap {
                date(timeZone: timeZone, withFormat: $0)
            }
            .first
    }

    func date(timeZone: TimeZone? = .current, withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
