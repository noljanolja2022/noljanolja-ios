//
//  CoinExchangeUseCase.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 18/10/2023.
//

import Combine
import Foundation

// MARK: - CoinExchangeUseCase

protocol CoinExchangeUseCase {
    func getCoin() -> AnyPublisher<CoinModel, Error>
}

// MARK: - CoinExchangeUseCaseImpl

final class CoinExchangeUseCaseImpl: CoinExchangeUseCase {
    static let shared: CoinExchangeUseCase = CoinExchangeUseCaseImpl()

    // MARK: Dependencies

    private let coinExchangeRepository: CoinExchangeRepository

    // MARK: Private

    private let coinSubject = CurrentValueSubject<CoinModel?, Never>(nil)

    init(coinExchangeRepository: CoinExchangeRepository = CoinExchangeRepositoryImpl.shared) {
        self.coinExchangeRepository = coinExchangeRepository
    }

    func getCoin() -> AnyPublisher<CoinModel, Error> {
        coinExchangeRepository
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
