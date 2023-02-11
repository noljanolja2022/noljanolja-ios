//
//  SignUpViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/02/2023.
//
//

import Combine
import SwiftUI

// MARK: - SignUpViewModel

final class SignUpViewModel: ObservableObject {
    // MARK: Dependencies

    private let authServices: AuthServicesType

    // MARK: Input

    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    let signUpTrigger = PassthroughSubject<(String, String), Never>()

    // MARK: Output

    @Binding var signUpStep: SignUpStep

    @Published var isSignUpButtonEnabled = false
    @Published var isLoading = false
    @Published var isAlertMessagePresented = false
    @Published var alertMessage = ""

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(authServices: AuthServicesType = AuthServices.default,
         signUpStep: Binding<SignUpStep>) {
        self.authServices = authServices
        self._signUpStep = signUpStep

        configure()
    }

    private func configure() {
        Publishers.CombineLatest3($email, $password, $confirmPassword)
            .sink(receiveValue: { [weak self] email, password, confirmPassword in
                let emailValidateResult = email.validateEmail()
                let passwordValidateResult = password.validatePassword()
                let matchPassword = password == confirmPassword

                self?.isSignUpButtonEnabled = emailValidateResult == nil && passwordValidateResult == nil && matchPassword
            })
            .store(in: &cancellables)

        signUpTrigger
            .handleEvents(receiveOutput: { _ in AppState.default.isLoading = true })
            .flatMap { [weak self] email, password -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signUp(email: email, password: password)
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                AppState.default.isLoading = false
                switch result {
                case let .success(idToken):
                    self?.signUpStep = .third
                    logger.info("Signed up with Email/Password - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign up with Email/Password failed: \(error.localizedDescription)")
                    self?.isAlertMessagePresented = true
                    self?.alertMessage = "Sign up with Email/Password failed.\nDETAIL: \(error.localizedDescription)"
                }
            })
            .store(in: &cancellables)
    }
}
