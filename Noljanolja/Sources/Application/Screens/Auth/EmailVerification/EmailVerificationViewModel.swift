//
//  EmailVerificationViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/02/2023.
//
//

import Combine
import SwiftUI

final class EmailVerificationViewModel: ObservableObject {
    // MARK: Dependencies

    private let authServices: AuthServicesType

    // MARK: Input

    let sendEmailVerificationTrigger = PassthroughSubject<Void, Never>()
    let verifyEmailTrigger = PassthroughSubject<Void, Never>()

    // MARK: Output

    @Binding var signUpStep: SignUpStep

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(authServices: AuthServicesType = AuthServices.default,
         signUpStep: Binding<SignUpStep>) {
        self.authServices = authServices
        self._signUpStep = signUpStep

        configure()
    }

    private func configure() {
        sendEmailVerificationTrigger
            .handleEvents(receiveOutput: { _ in AppState.default.isLoading = true })
            .flatMap { [weak self] _ -> AnyPublisher<Result<Void, Error>, Never> in
                guard let self else { return Empty<Result<Void, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .sendEmailVerification()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { result in
                AppState.default.isLoading = false
                switch result {
                case .success:
                    logger.info("Send email verification successful")
                case let .failure(error):
                    logger.error("Send email verification failed: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)

        verifyEmailTrigger
            .handleEvents(receiveOutput: { _ in AppState.default.isLoading = true })
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .verifyEmail()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { result in
                AppState.default.isLoading = false
                switch result {
                case .success:
                    logger.info("Verify email successful")
                case let .failure(error):
                    logger.error("Verify email failed: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)
    }
}
