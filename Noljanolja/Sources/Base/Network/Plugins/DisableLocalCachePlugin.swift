//
//  DisableLocalCachePlugin.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation
import Moya

struct DisableLocalCachePlugin: PluginType {
    func prepare(_ request: URLRequest, target _: TargetType) -> URLRequest {
        var request = request
        request.cachePolicy = .reloadIgnoringLocalCacheData
        return request
    }
}
