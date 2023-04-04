//
//  TargetType+Extension.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation
import Moya

extension TargetType {
    var headers: [String: String]? {
        nil
    }

    var validationType: ValidationType {
        .successCodes
    }
}
