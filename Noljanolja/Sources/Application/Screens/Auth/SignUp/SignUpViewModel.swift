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

    @Published var emailErrorMessage: String? = nil
    @Published var passwordErrorMessage: String? = nil
    @Published var confirmPasswordErrorMessage: String? = nil

    @Published var isSignUpButtonEnabled = false
    @Published var isAlertMessagePresented = false
    @Published var alertMessage = ""

    @Published var isShowingEmailVerificationView = false

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(authServices: AuthServicesType = AuthServices.default,
         signUpStep: Binding<SignUpStep>) {
        self.authServices = authServices
        self._signUpStep = signUpStep

        configure()
    }

    private func configure() {
        let emailValidateResult = $email
            .removeDuplicates()
            .dropFirst()
            .map { StringValidator.validateEmail($0) }
            .handleEvents(receiveOutput: { [weak self] result in
                self?.emailErrorMessage = result?.message
            })

        let passwordsValidateResult = Publishers
            .CombineLatest(
                $password.removeDuplicates(),
                $confirmPassword.removeDuplicates()
            )
            .dropFirst()
            .map {
                (
                    StringValidator.validatePassword($0.0),
                    StringValidator.validatePasswords(password: $0.0, confirmPassword: $0.1)
                )
            }
            .handleEvents(receiveOutput: { [weak self] passwordValidateResult, confirmPasswordValidateResult in
                self?.passwordErrorMessage = passwordValidateResult?.message
                self?.confirmPasswordErrorMessage = confirmPasswordValidateResult?.message
            })

        Publishers.CombineLatest(emailValidateResult, passwordsValidateResult)
            .sink(receiveValue: { [weak self] emailValidateResult, passwordsValidateResult in
                self?.isSignUpButtonEnabled = emailValidateResult == nil
                    && passwordsValidateResult.0 == nil
                    && passwordsValidateResult.1 == nil
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
                    logger.info("Signed up with Email/Password - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign up with Email/Password failed: \(error.localizedDescription)")

                    switch error {
                    case FirebaseAuthError.emailNotVerified as FirebaseAuthError:
                        self?.isShowingEmailVerificationView = true
                        self?.signUpStep = .third
                    default:
                        self?.isAlertMessagePresented = true
                        self?.alertMessage = L10n.Common.Error.message
                    }
                }
            })
            .store(in: &cancellables)
    }
}
