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
            .flatMap { [weak self] _ -> AnyPublisher<String, Error> in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.authorizationServices.signInWithApple()
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        logger.info("Sign in with Apple Fail: \(error.localizedDescription)")
                    case .finished:
                        logger.info("Sign in with Apple finished")
                    }
                },
                receiveValue: { idToken in
                    logger.info("Sign in with Apple IDToken: \(idToken)")
                }
            )
            .store(in: &cancellables)

        input.signInWithGoogleTrigger
            .flatMap { [weak self] _ -> AnyPublisher<String, Error> in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.authorizationServices.signInWithGoogle()
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        logger.info("Sign in with Google Fail: \(error.localizedDescription)")
                    case .finished:
                        logger.info("Sign in with Google finished")
                    }
                },
                receiveValue: { idToken in
                    logger.info("Sign in with Google IDToken: \(idToken)")
                }
            )
            .store(in: &cancellables)

        input.signInWithKakaoTrigger
            .flatMap { [weak self] _ -> AnyPublisher<String, Error> in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.authorizationServices.signInWithKakao()
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        logger.info("Sign in with Kakaofail: \(error.localizedDescription)")
                    case .finished:
                        logger.info("Sign in with Kakaofinished")
                    }
                },
                receiveValue: { accessToken in
                    logger.info("Sign in with Kakaotoken: \(accessToken)")
                }
            )
            .store(in: &cancellables)

        input.signInWithNaverTrigger
            .flatMap { [weak self] _ -> AnyPublisher<String, Error> in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.authorizationServices.signInWithNaver()
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        logger.info("Sign in with Naver fail: \(error.localizedDescription)")
                    case .finished:
                        logger.info("Sign in with Naver finished")
                    }
                },
                receiveValue: { accessToken in
                    logger.info("Sign in with Naver token: \(accessToken)")
                }
            )
            .store(in: &cancellables)
    }
}
