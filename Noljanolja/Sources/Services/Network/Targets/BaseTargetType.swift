//
//  BaseTargetType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation
import Moya

// MARK: - BaseTargetType

protocol BaseTargetType: TargetType {}

extension BaseTargetType {
    var baseURL: URL {
        guard let url = URL(string: NetworkConfigs.BaseUrl.baseUrl) else {
            fatalError("Cannot parse endpoint url")
        }
        return url
    }
}
