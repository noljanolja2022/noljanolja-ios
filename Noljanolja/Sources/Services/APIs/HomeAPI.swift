//
//  HomeAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Combine
import Foundation
import Moya

// MARK: - HomeAPITargets

private enum HomeAPITargets {
    struct ID: BaseTargetType {
        var path: String { "id" }
        let method: Moya.Method = .post
        var task: Task { .requestParameters(parameters: [:], encoding: JSONEncoding.default) }

        let username: String
        let password: String
    }
}

// MARK: - HomeAPIType

protocol HomeAPIType {
    func signIn(username: String, password: String) -> AnyPublisher<HomeModel, Error>
}

// MARK: - HomeAPI

final class HomeAPI: HomeAPIType {
    private let api: ApiType = Api.default

    func signIn(username: String, password: String) -> AnyPublisher<HomeModel, Error> {
        api.request(target: HomeAPITargets.ID(username: username, password: password))
    }
}
