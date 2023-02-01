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
        return nil
    }

    var urlParameters: [String: Any]? {
        return nil
    }

    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }

    var sampleData: Data {
        return Data()
    }

    var validate: Bool {
        return false
    }
}
