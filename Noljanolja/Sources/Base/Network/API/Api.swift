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
    func request(target: TargetType) -> AnyPublisher<Response, Error>
    func request(target: TargetType) -> AnyPublisher<Void, Error>
    func request(target: TargetType, atKeyPath: String?) -> AnyPublisher<Void, Error>

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

    func request(target: TargetType) -> AnyPublisher<Response, Error> {
        provider
            .requestPublisher(MultiTarget(target))
            .filterSuccessfulStatusCodes()
            .mapError { error -> Error in error }
            .eraseToAnyPublisher()
    }

    func request(target: TargetType) -> AnyPublisher<Void, Error> {
        provider
            .requestPublisher(MultiTarget(target))
            .filterSuccessfulStatusCodes()
            .mapToVoid()
            .mapError { error -> Error in error }
            .eraseToAnyPublisher()
    }

    func request(target: TargetType, atKeyPath: String?) -> AnyPublisher<Void, Error> {
        provider
            .requestPublisher(MultiTarget(target))
            .filterSuccessfulStatusCodes()
            .mapToVoid()
            .mapError { error -> Error in error }
            .eraseToAnyPublisher()
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
            .tryMap {
                try $0.map(Model.self, atKeyPath: atKeyPath)
            }
            .mapError { error -> Error in error }
            .eraseToAnyPublisher()
    }
}
