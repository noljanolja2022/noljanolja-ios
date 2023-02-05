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

    var urlParameters: [String: Any]? {
        nil
    }

    var parameterEncoding: ParameterEncoding {
        JSONEncoding.default
    }

    var sampleData: Data {
        Data()
    }

    var validate: Bool {
        false
    }
}
