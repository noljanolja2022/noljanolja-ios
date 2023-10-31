//
//  Interceptor.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/04/2023.
//

import Alamofire
import Combine
import Foundation

final class RefreshTokenInterceptor: RequestInterceptor {
    static let `default` = RefreshTokenInterceptor()

    // MARK: Denependencies

    private let authUseCases: AuthUseCases

    // MARK: Private

    private let maxRetryTime = 3

    init(authUseCases: AuthUseCases = AuthUseCasesImpl.default) {
        self.authUseCases = authUseCases
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401,
              request.retryCount < maxRetryTime else {
            return completion(.doNotRetryWithError(error))
        }

        var cancellable = AnyCancellable {}
        cancellable = authUseCases.getIDTokenResult()
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case .finished:
                        completion(.retry)
                    case .failure:
                        completion(.retryWithDelay(3))
                    }
                    cancellable.cancel()
                },
                receiveValue: { _ in }
            )
    }
}
