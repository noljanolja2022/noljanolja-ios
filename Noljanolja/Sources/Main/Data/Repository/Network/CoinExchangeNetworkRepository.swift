//
//  CoinExchangeNetworkRepository.swift
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

        let points: Double
        
        var parameters: [String: Any] {
            [
                "points": points
            ]
        }
    }
}

// MARK: - CoinExchangeNetworkRepository

protocol CoinExchangeNetworkRepository {
    func getCoin() -> AnyPublisher<CoinModel, Error>
    func getCoinExchangeRate() -> AnyPublisher<CoinExchangeRate, Error>
    func convert(_ points: Double) -> AnyPublisher<CoinExchangeResult, Error>
}

// MARK: - CoinExchangeNetworkRepositoryImpl

final class CoinExchangeNetworkRepositoryImpl: CoinExchangeNetworkRepository {
    static let shared: CoinExchangeNetworkRepository = CoinExchangeNetworkRepositoryImpl()

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
    
    func convert(_ points: Double) -> AnyPublisher<CoinExchangeResult, Error> {
        api.request(
            target: CoinExchangeTargets.Convert(points: points),
            atKeyPath: "data"
        )
    }
}
