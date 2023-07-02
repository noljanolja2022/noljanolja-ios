//
//  CountryModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//

import Foundation

// MARK: - Country

struct Country: Equatable {
    let code: String
    let flag: String
    let name: String
    let prefix: String

    init(_ code: String, _ flag: String, _ name: String, _ prefix: String) {
        self.code = code
        self.flag = flag
        self.name = name
        self.prefix = prefix
    }
}
