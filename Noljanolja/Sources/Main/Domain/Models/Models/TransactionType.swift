//
//  TransactionType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/05/2023.
//

import Foundation

// MARK: - TransactionType

enum TransactionType: String, Equatable, CaseIterable, Decodable {
    case all = "ALL"
    case received = "RECEIVED"
    case pay = "SPENT"
}

extension TransactionType {
    var title: String {
        switch self {
        case .all: return "All"
        case .received: return "Received"
        case .pay: return "Pay"
        }
    }
}
