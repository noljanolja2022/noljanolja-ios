//
//  Result+Extension.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import Foundation

extension Swift.Result {
    var success: Success? {
        switch self {
        case let .success(success): return success
        case .failure: return nil
        }
    }

    var failure: Failure? {
        switch self {
        case .success: return nil
        case let .failure(failure): return failure
        }
    }
}
