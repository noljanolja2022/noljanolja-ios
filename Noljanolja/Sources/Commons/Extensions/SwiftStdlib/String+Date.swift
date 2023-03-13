//
//  String+Date.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/03/2023.
//

import Foundation

extension String {
    func date(withFormats formats: [String]) -> Date? {
        formats.compactMap {
            self.date(withFormat: $0)
        }
        .first
    }
}
