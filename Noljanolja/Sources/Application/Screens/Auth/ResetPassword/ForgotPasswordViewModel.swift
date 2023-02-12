//
//  ForgotPasswordViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import Combine

final class ForgotPasswordViewModel: ObservableObject {
    // MARK: Dependencies

    private let authServices: AuthServicesType

    // MARK: Input

    @Published var email = ""

    let resetPasswordTrigger = PassthroughSubject<String, Never>()

    // MARK: Output

    @Published var isResetButtonEnabled = false
    @Published var isSuccess = false
    @Published var isAlertMessagePresented = false
    @Published var alertMessage = ""

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(authServices: AuthServicesType = AuthServices.default) {
        self.authServices = authServices

        configure()
    }

    private func configure() {
        $email
            .sink { [weak self] in self?.isResetButtonEnabled = $0.isValidEmail }
            .store(in: &cancellables)

        resetPasswordTrigger
            .handleEvents(receiveOutput: { _ in AppState.default.isLoading = true })
            .flatMap { [weak self] email -> AnyPublisher<Result<Void, Error>, Never> in
                guard let self else { return Empty<Result<Void, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .sendPasswordReset(email: email)
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                AppState.default.isLoading = false
                switch result {
                case .success:
                    logger.info("Reset password sucessful")
                    self?.isSuccess = true
                case let .failure(error):
                    logger.error("Reset password failed: \(error.localizedDescription)")
                    self?.isSuccess = false
                    self?.isAlertMessagePresented = true
                    self?.alertMessage = "Reset password failed.\nDETAIL: \(error.localizedDescription)"
                }
            })
            .store(in: &cancellables)
    }
}
