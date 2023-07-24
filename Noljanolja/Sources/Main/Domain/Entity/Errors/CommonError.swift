//
//  CommonError.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation

// MARK: - CommonError

enum CommonError: Error {
    case captureSelfNotFound
    case captureObjectNotFound(message: String)
    case informationNotFound(message: String)
    case currentUserNotFound
    case unknown
}
