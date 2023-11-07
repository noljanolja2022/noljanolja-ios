//
//  CouponKeyword.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//

import Foundation

struct CouponKeyword: Equatable {
    let keyword: String
    let createdAt: Date

    init(keyword: String, createdAt: Date = Date()) {
        self.keyword = keyword
        self.createdAt = createdAt
    }
}
