//
//  TransactionFilterType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/05/2023.
//

import Foundation

// MARK: - TransactionFilterType

enum TransactionFilterType: String, Equatable, CaseIterable {
    case all = "ALL"
    case received = "RECEIVED"
    case spent = "SPENT"
}

extension TransactionFilterType {
    var title: String {
        switch self {
        case .all: return "All"
        case .received: return "Received"
        case .spent: return "Exchange"
        }
    }
}
