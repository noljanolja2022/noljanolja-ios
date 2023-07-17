//
//  Publisher+FlatMapTranforming.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/02/2023.
//

import Combine
import Foundation

extension Publisher {
    func flatMapToResult<P>(maxPublishers: Subscribers.Demand = .unlimited,
                            _ transform: @escaping (Self.Output) -> P) -> AnyPublisher<Result<P.Output, P.Failure>, Failure> where P: Publisher {
        flatMap(maxPublishers: maxPublishers) { output -> AnyPublisher<Result<P.Output, P.Failure>, Never> in
            transform(output).mapToResult()
        }
        .eraseToAnyPublisher()
    }
}

extension Publisher where Self.Failure == Never {
    func flatMapLatestToResult<P>(_ transform: @escaping (Self.Output) -> P) -> AnyPublisher<Result<P.Output, P.Failure>, Failure> where P: Publisher {
        flatMapLatest { output -> AnyPublisher<Result<P.Output, P.Failure>, Never> in
            transform(output).mapToResult()
        }
        .eraseToAnyPublisher()
    }
}
