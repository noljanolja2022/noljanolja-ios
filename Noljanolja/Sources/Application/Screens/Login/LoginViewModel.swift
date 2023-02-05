//
//  LoginViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import Combine
import Foundation

extension LoginViewModel {
    struct Input {
        let signInWithAppleTrigger = PassthroughSubject<Void, Never>()
        let signInWithGoogleTrigger = PassthroughSubject<Void, Never>()
        let signInWithKakaoTrigger = PassthroughSubject<Void, Never>()
        let signInWithNaverTrigger = PassthroughSubject<Void, Never>()
    }

    struct Output {}
}

// MARK: - LoginViewModel

final class LoginViewModel: ObservableObject {
    let input = Input()
    let output = Output()

    private let authorizationServices: AuthorizationServicesType

    private var cancellables = Set<AnyCancellable>()

    init(authorizationServices: AuthorizationServicesType = AuthorizationServices()) {
        self.authorizationServices = authorizationServices

        configure()
    }

    private func configure() {
        input.signInWithAppleTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authorizationServices
                    .signInWithApple()
                    .eraseToResultAnyPublisher()
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        logger.info("Sign in with Apple failed: \(error.localizedDescription)")
                    case .finished:
                        logger.info("Sign in with Apple finished")
                    }
                },
                receiveValue: { result in
                    switch result {
                    case let .failure(error):
                        logger.info("Sign in with Apple failed: \(error.localizedDescription)")
                    case let .success(idToken):
                        logger.info("Sign in with Apple - Token: \(idToken)")
                    }
                }
            )
            .store(in: &cancellables)

        input.signInWithGoogleTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authorizationServices
                    .signInWithGoogle()
                    .eraseToResultAnyPublisher()
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        logger.info("Sign in with Google failed: \(error.localizedDescription)")
                    case .finished:
                        logger.info("Sign in with Google finished")
                    }
                },
                receiveValue: { result in
                    switch result {
                    case let .failure(error):
                        logger.info("Sign in with Google failed: \(error.localizedDescription)")
                    case let .success(idToken):
                        logger.info("Sign in with Google - Token: \(idToken)")
                    }
                }
            )
            .store(in: &cancellables)

        input.signInWithKakaoTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authorizationServices
                    .signInWithKakao()
                    .eraseToResultAnyPublisher()
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        logger.info("Sign in with Kakao failed: \(error.localizedDescription)")
                    case .finished:
                        logger.info("Sign in with Kakao finished")
                    }
                },
                receiveValue: { result in
                    switch result {
                    case let .failure(error):
                        logger.info("Sign in with Kakao failed: \(error.localizedDescription)")
                    case let .success(idToken):
                        logger.info("Sign in with Kakao - Token: \(idToken)")
                    }
                }
            )
            .store(in: &cancellables)

        input.signInWithNaverTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authorizationServices
                    .signInWithNaver()
                    .eraseToResultAnyPublisher()
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        logger.info("Sign in with Naver failed: \(error.localizedDescription)")
                    case .finished:
                        logger.info("Sign in with Naver finished")
                    }
                },
                receiveValue: { result in
                    switch result {
                    case let .failure(error):
                        logger.info("Sign in with Naver failed: \(error.localizedDescription)")
                    case let .success(idToken):
                        logger.info("Sign in with Naver - Token: \(idToken)")
                    }
                }
            )
            .store(in: &cancellables)
    }
}
