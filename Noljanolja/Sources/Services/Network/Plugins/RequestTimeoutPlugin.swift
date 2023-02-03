//
//  RequestTimeoutPlugin.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation
import Moya

// MARK: - RequestTimeoutConfigurable

protocol RequestTimeoutConfigurable {
    var timeout: TimeInterval { get }
}

// MARK: - RequestTimeoutPlugin

struct RequestTimeoutPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target.rawTarget as? RequestTimeoutConfigurable else { return request }

        var request = request
        request.timeoutInterval = target.timeout
        return request
    }
}
