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
}
