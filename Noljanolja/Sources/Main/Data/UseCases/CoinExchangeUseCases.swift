//
//  CoinExchangeUseCases.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 18/10/2023.
//

import Combine
import Foundation

// MARK: - CoinExchangeUseCases

protocol CoinExchangeUseCases {
    func getCoin() -> AnyPublisher<CoinModel, Error>
}

// MARK: - CoinExchangeUseCasesImpl

final class CoinExchangeUseCasesImpl: CoinExchangeUseCases {
    static let shared: CoinExchangeUseCases = CoinExchangeUseCasesImpl()

    // MARK: Dependencies

    private let coinExchangeNetworkRepository: CoinExchangeNetworkRepository

    // MARK: Private

    private let coinSubject = CurrentValueSubject<CoinModel?, Never>(nil)

    init(coinExchangeNetworkRepository: CoinExchangeNetworkRepository = CoinExchangeNetworkRepositoryImpl.shared) {
        self.coinExchangeNetworkRepository = coinExchangeNetworkRepository
    }

    func getCoin() -> AnyPublisher<CoinModel, Error> {
        coinExchangeNetworkRepository
            .getCoin()
            .handleEvents(receiveOutput: { [weak self] in
                self?.coinSubject.send($0)
            })
            .flatMapLatest { [weak self] _ in
                guard let self else {
                    return Empty<CoinModel, Error>().eraseToAnyPublisher()
                }
                return self.coinSubject
                    .compactMap { $0 }
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
