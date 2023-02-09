//
//  SignInViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import Combine
import Foundation

// MARK: - SignInViewModel

final class SignInViewModel: ObservableObject {
    // MARK: Dependencies

    private let authServices: AuthServicesType

    // MARK: Input

    let forgotPasswordTrigger = PassthroughSubject<Void, Never>()
    let signInWithEmailPasswordTrigger = PassthroughSubject<(String, String), Never>()
    let signInWithAppleTrigger = PassthroughSubject<Void, Never>()
    let signInWithGoogleTrigger = PassthroughSubject<Void, Never>()
    let signInWithKakaoTrigger = PassthroughSubject<Void, Never>()
    let signInWithNaverTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(authServices: AuthServicesType = AuthServices.default) {
        self.authServices = authServices

        configure()
    }

    private func configure() {
        signInWithEmailPasswordTrigger
            .flatMap { [weak self] email, password -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signIn(email: email, password: password)
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { result in
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Email/Password - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Email/Password failed: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)

        signInWithAppleTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithApple()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { result in
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Apple - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Apple failed: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)

        signInWithGoogleTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithGoogle()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { result in
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Google - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Google failed: \(error.localizedDescription)")
                }
            }
            )
            .store(in: &cancellables)

        signInWithKakaoTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithKakao()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { result in
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Kakao - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Kakao failed: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)

        signInWithNaverTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithNaver()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { result in
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Naver - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Naver failed: \(error.localizedDescription)")
                }
            }
            )
            .store(in: &cancellables)
    }
}
