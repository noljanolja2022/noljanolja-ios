//
//  SignUpViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/02/2023.
//
//

import Combine

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

    @Published var isSignUpButtonEnabled = false
    @Published var isLoading = false
    @Published var isAlertMessagePresented = false
    @Published var alertMessage = ""

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(authServices: AuthServicesType = AuthServices.default) {
        self.authServices = authServices

        configure()
    }

    private func configure() {
        signUpTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.isLoading = true })
            .flatMap { [weak self] email, password -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signUp(email: email, password: password)
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                self?.isLoading = false
                switch result {
                case let .success(idToken):
                    logger.info("Signed up with Email/Password - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Email/Password failed: \(error.localizedDescription)")
                    self?.isAlertMessagePresented = true
                    self?.alertMessage = "Sign in with Email/Password failed.\nDETAIL: \(error.localizedDescription)"
                }
            })
            .store(in: &cancellables)
    }
}
