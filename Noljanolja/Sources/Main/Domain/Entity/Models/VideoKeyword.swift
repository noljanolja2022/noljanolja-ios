//
//  VideoKeyword.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/07/2023.
//

import Foundation

struct VideoKeyword: Equatable {
    let keyword: String
    let createdAt: Date

    init(keyword: String, createdAt: Date = Date()) {
        self.keyword = keyword
        self.createdAt = createdAt
    }
}
