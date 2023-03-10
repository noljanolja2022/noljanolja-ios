//
//  CommonError.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation

// MARK: - CommonError

enum CommonError: Error {
    case unknown
}

// MARK: - NetworkError

enum NetworkError: Error {
    case mapping(String)
}
