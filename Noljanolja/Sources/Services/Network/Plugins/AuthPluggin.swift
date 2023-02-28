//
//  AuthPluggin.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation
import Moya

// MARK: - AuthConfigurable

protocol AuthConfigurable {}

// MARK: - AuthPluggin

struct AuthPluggin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard target.rawTarget is AuthConfigurable else { return request }

        var request = request
        if let token = AuthStore.default.getToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}
