//
//  TransactionStatusType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/05/2023.
//

import Foundation

enum TransactionStatusType: String, Decodable {
    case completed = "COMPLETED"
    case pending = "PENDING"
    case unknown

    var title: String {
        switch self {
        case .completed:
            return L10n.commonComplete
        case .pending:
            return "Pending"
        case .unknown:
            return ""
        }
    }
}
