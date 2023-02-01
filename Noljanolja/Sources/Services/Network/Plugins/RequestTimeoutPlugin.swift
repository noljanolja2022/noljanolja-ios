//
//  RequestTimeoutPlugin.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation
import Moya

protocol RequestTimeoutConfigurable {
    var timeout: TimeInterval { get }
}

struct RequestTimeoutPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target.rawTarget as? RequestTimeoutConfigurable else { return request }

        var request = request
        request.timeoutInterval = target.timeout
        return request
    }
}
