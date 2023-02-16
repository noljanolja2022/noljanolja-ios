//
//  ResetPasswordViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import Combine

// MARK: - ResetPasswordViewModelDelegate

protocol ResetPasswordViewModelDelegate: AnyObject {}

// MARK: - ResetPasswordViewModelType

protocol ResetPasswordViewModelType: ObservableObject {
    // MARK: State

    var email: String { get set }

    var emailErrorMessage: String? { get set }
    var isResetButtonEnabled: Bool { get set }

    var isSuccess: Bool { get set }
    var isAlertMessagePresented: Bool { get set }
    var alertMessage: String { get set }

    // MARK: Action

    var resetPasswordTrigger: PassthroughSubject<String, Never> { get }
}

// MARK: - ResetPasswordViewModel

final class ResetPasswordViewModel: ResetPasswordViewModelType {
    // MARK: Dependencies

    private weak var delegate: ResetPasswordViewModelDelegate?
    private let authServices: AuthServicesType

    // MARK: State

    @Published var email = ""

    @Published var emailErrorMessage: String? = nil
    @Published var isResetButtonEnabled = false

    @Published var isSuccess = false
    @Published var isAlertMessagePresented = false
    @Published var alertMessage = ""

    // MARK: Action

    let resetPasswordTrigger = PassthroughSubject<String, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: ResetPasswordViewModelDelegate? = nil,
         authServices: AuthServicesType = AuthServices.default) {
        self.delegate = delegate
        self.authServices = authServices

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

        emailValidateResult
            .sink { [weak self] in self?.isResetButtonEnabled = $0 == nil }
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
                    self?.alertMessage = L10n.Common.Error.message
                }
            })
            .store(in: &cancellables)
    }
}
