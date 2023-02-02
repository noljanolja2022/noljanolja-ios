//
//  AuthorizationAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Combine
import Foundation
import Moya

// MARK: - AuthorizationTargets

private enum AuthorizationTargets {
    struct Login: BaseTargetType {
        var path: String { "login" }
        let method: Moya.Method = .post
        var task: Task { .requestParameters(parameters: [:], encoding: JSONEncoding.default) }

        let username: String
        let password: String
    }
}

// MARK: - AuthorizationAPIType

protocol AuthorizationAPIType {
    func login(username: String, password: String) -> AnyPublisher<AuthorizationModel, Error>
}

// MARK: - AuthorizationAPI

final class AuthorizationAPI: AuthorizationAPIType {
    private let api: ApiType = Api.default

    func login(username: String, password: String) -> AnyPublisher<AuthorizationModel, Error> {
        api.request(target: AuthorizationTargets.Login(username: username, password: password))
    }
}
