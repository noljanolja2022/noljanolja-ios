//
//  AuthorizationPluggin.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation
import Moya

// MARK: - AuthorizationConfigurable

protocol AuthorizationConfigurable {}

// MARK: - AuthorizationPluggin

struct AuthorizationPluggin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard target.rawTarget is AuthorizationConfigurable else { return request }

        var request = request
        if let token = AuthStore.default.getToken() {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }

        return request
    }
}
