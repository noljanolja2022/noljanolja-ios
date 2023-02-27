//
//  Api.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Combine
import CombineMoya
import Foundation
import Moya

// MARK: - ApiType

protocol ApiType {
    func request<Model: Decodable>(target: TargetType) -> AnyPublisher<Model, Error>
    func request<Model: Decodable>(target: TargetType, atKeyPath: String?) -> AnyPublisher<Model, Error>
}

// MARK: - Api

final class Api: ApiType {
    static let `default` = Api()

    private let provider: MoyaProvider<MultiTarget>

    init(provider: MoyaProvider<MultiTarget> = ApiProvider.default) {
        self.provider = provider
    }

    func request<Model: Decodable>(target: TargetType) -> AnyPublisher<Model, Error> {
        provider
            .requestPublisher(MultiTarget(target))
            .filterSuccessfulStatusCodes()
            .map(Model.self)
            .mapError { error -> Error in error }
            .eraseToAnyPublisher()
    }
    
    func request<Model: Decodable>(target: TargetType, atKeyPath: String?) -> AnyPublisher<Model, Error> {
        provider
            .requestPublisher(MultiTarget(target))
            .filterSuccessfulStatusCodes()
            .tryMap { try $0.map(Model.self, atKeyPath: atKeyPath) }
            .mapError { error -> Error in error }
            .eraseToAnyPublisher()
    }
}
