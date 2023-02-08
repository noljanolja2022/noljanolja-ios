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
        let signOutTrigger = PassthroughSubject<Void, Never>()
    }

    struct Output {}
}

// MARK: - LoginViewModel

final class LoginViewModel: ObservableObject {
    let input = Input()
    let output = Output()

    private let authServices: AuthServicesType

    private var cancellables = Set<AnyCancellable>()

    init(authServices: AuthServicesType = AuthServices()) {
        self.authServices = authServices

        configure()
    }

    private func configure() {
        input.signInWithAppleTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithApple()
                    .eraseToResultAnyPublisher()
            }
            .sink(
                receiveValue: { result in
                    switch result {
                    case let .success(idToken):
                        logger.info("Signed in with Apple - Token: \(idToken)")
                    case let .failure(error):
                        logger.error("Sign in with Apple failed: \(error.localizedDescription)")
                    }
                }
            )
            .store(in: &cancellables)

        input.signInWithGoogleTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithGoogle()
                    .eraseToResultAnyPublisher()
            }
            .sink(
                receiveValue: { result in
                    switch result {
                    case let .success(idToken):
                        logger.info("Signed in with Google - Token: \(idToken)")
                    case let .failure(error):
                        logger.error("Sign in with Google failed: \(error.localizedDescription)")
                    }
                }
            )
            .store(in: &cancellables)

        input.signInWithKakaoTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithKakao()
                    .eraseToResultAnyPublisher()
            }
            .sink(
                receiveValue: { result in
                    switch result {
                    case let .success(idToken):
                        logger.info("Signed in with Kakao - Token: \(idToken)")
                    case let .failure(error):
                        logger.error("Sign in with Kakao failed: \(error.localizedDescription)")
                    }
                }
            )
            .store(in: &cancellables)

        input.signInWithNaverTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithNaver()
                    .eraseToResultAnyPublisher()
            }
            .sink(
                receiveValue: { result in
                    switch result {
                    case let .success(idToken):
                        logger.info("Signed in with Naver - Token: \(idToken)")
                    case let .failure(error):
                        logger.error("Sign in with Naver failed: \(error.localizedDescription)")
                    }
                }
            )
            .store(in: &cancellables)

        input.signOutTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<Void, Error>, Never> in
                guard let self else { return Empty<Result<Void, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signOut()
                    .eraseToResultAnyPublisher()
            }
            .sink(
                receiveValue: { result in
                    switch result {
                    case .success:
                        logger.info("Signed out")
                    case let .failure(error):
                        logger.error("Sign out failed: \(error.localizedDescription)")
                    }
                }
            )
            .store(in: &cancellables)
    }
}
