//
//  AuthorizationPluggin.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation
import Moya

protocol AuthorizationConfigurable {}

struct AuthorizationPluggin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard target.rawTarget is AuthorizationConfigurable else { return request }

//        Do something with request
//        var request = request
//        request.addValue("Bearer _____", forHTTPHeaderField: "Authorization")
        return request
    }
}
