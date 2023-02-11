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

    @Published var email = ""
    @Published var password = ""

    let forgotPasswordTrigger = PassthroughSubject<Void, Never>()
    let signInWithEmailPasswordTrigger = PassthroughSubject<(String, String), Never>()
    let signInWithAppleTrigger = PassthroughSubject<Void, Never>()
    let signInWithGoogleTrigger = PassthroughSubject<Void, Never>()
    let signInWithKakaoTrigger = PassthroughSubject<Void, Never>()
    let signInWithNaverTrigger = PassthroughSubject<Void, Never>()

    // MARK: Output

    @Published var isSignInButtonEnabled = true
    @Published var isAlertMessagePresented = false
    @Published var alertMessage = ""

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(authServices: AuthServicesType = AuthServices.default) {
        self.authServices = authServices

        configure()
    }

    private func configure() {
        Publishers.CombineLatest($email, $password)
            .sink(receiveValue: { [weak self] email, password in
                let emailValidateResult = email.validateEmail()
                let passwordValidateResult = password.validatePassword()

                self?.isSignInButtonEnabled = emailValidateResult == nil && passwordValidateResult == nil
            })
            .store(in: &cancellables)

        signInWithEmailPasswordTrigger
            .handleEvents(receiveOutput: { _ in AppState.default.isLoading = true })
            .flatMap { [weak self] email, password -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signIn(email: email, password: password)
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                AppState.default.isLoading = false
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Email/Password - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Email/Password failed: \(error.localizedDescription)")
                    self?.isAlertMessagePresented = true
                    self?.alertMessage = "Sign in with Email/Password failed.\nDETAIL: \(error.localizedDescription)"
                }
            })
            .store(in: &cancellables)

        signInWithAppleTrigger
            .handleEvents(receiveOutput: { _ in AppState.default.isLoading = true })
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithApple()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                AppState.default.isLoading = false
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Apple - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Apple failed: \(error.localizedDescription)")
                    self?.isAlertMessagePresented = true
                    self?.alertMessage = "Sign in with Apple failed.\nDETAIL: \(error.localizedDescription)"
                }
            })
            .store(in: &cancellables)

        signInWithGoogleTrigger
            .handleEvents(receiveOutput: { _ in AppState.default.isLoading = true })
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithGoogle()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                AppState.default.isLoading = false
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Google - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Google failed: \(error.localizedDescription)")
                    self?.isAlertMessagePresented = true
                    self?.alertMessage = "Sign in with Google failed.\nDETAIL: \(error.localizedDescription)"
                }
            }
            )
            .store(in: &cancellables)

        signInWithKakaoTrigger
            .handleEvents(receiveOutput: { _ in AppState.default.isLoading = true })
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithKakao()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                AppState.default.isLoading = false
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Kakao - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Kakao failed: \(error.localizedDescription)")
                    self?.isAlertMessagePresented = true
                    self?.alertMessage = "Sign in with Kakao failed.\nDETAIL: \(error.localizedDescription)"
                }
            })
            .store(in: &cancellables)

        signInWithNaverTrigger
            .handleEvents(receiveOutput: { _ in AppState.default.isLoading = true })
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithNaver()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                AppState.default.isLoading = false
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Naver - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Naver failed: \(error.localizedDescription)")
                    self?.isAlertMessagePresented = true
                    self?.alertMessage = "Sign in with Naver failed.\nDETAIL: \(error.localizedDescription)"
                }
            }
            )
            .store(in: &cancellables)
    }
}
