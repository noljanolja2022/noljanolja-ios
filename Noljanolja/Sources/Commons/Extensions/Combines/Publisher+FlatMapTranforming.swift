//
//  Publisher+FlatMapTranforming.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/02/2023.
//

import Combine
import Foundation

extension Publisher {
    func eraseToResultAnyPublisher() -> AnyPublisher<Result<Output, Failure>, Never> {
        map { Result.success($0) }
            .catch { error -> AnyPublisher<Result<Output, Failure>, Never> in
                Just(Result.failure(error)).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
