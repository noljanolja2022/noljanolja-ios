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
        var request = request
        if let target = target.rawTarget as? RequestTimeoutConfigurable {
            request.timeoutInterval = target.timeout
        } else {
            request.timeoutInterval = 60
        }
        return request
    }
}
