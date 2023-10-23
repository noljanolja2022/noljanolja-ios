//
//  CoinExchangeRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 18/10/2023.
//

import Combine
import Foundation
import Moya
import UIKit

// MARK: - CoinExchangeTargets

private enum CoinExchangeTargets {
    struct GetCoin: BaseAuthTargetType {
        var path: String { "v1/coin-exchange/me/balance" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }
    }
    
    struct GetCoinExchangeRate: BaseAuthTargetType {
        var path: String { "v1/coin-exchange/rate" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }
    }
    
    struct Convert: BaseAuthTargetType {
        var path: String { "v1/coin-exchange/me/convert" }
        let method: Moya.Method = .post
        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }

        let points: Int
        
        var parameters: [String: Any] {
            [
                "points": points
            ]
        }
    }
}

// MARK: - CoinExchangeRepository

protocol CoinExchangeRepository {
    func getCoin() -> AnyPublisher<CoinModel, Error>
    func getCoinExchangeRate() -> AnyPublisher<CoinExchangeRate, Error>
    func convert(_ points: Int) -> AnyPublisher<CoinExchangeResult, Error>
}

// MARK: - CoinExchangeRepositoryImpl

final class CoinExchangeRepositoryImpl: CoinExchangeRepository {
    static let shared: CoinExchangeRepository = CoinExchangeRepositoryImpl()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getCoin() -> AnyPublisher<CoinModel, Error> {
        api.request(
            target: CoinExchangeTargets.GetCoin(),
            atKeyPath: "data"
        )
    }
    
    func getCoinExchangeRate() -> AnyPublisher<CoinExchangeRate, Error> {
        api.request(
            target: CoinExchangeTargets.GetCoinExchangeRate(),
            atKeyPath: "data"
        )
    }
    
    func convert(_ points: Int) -> AnyPublisher<CoinExchangeResult, Error> {
        api.request(
            target: CoinExchangeTargets.Convert(points: points),
            atKeyPath: "data"
        )
    }
}
