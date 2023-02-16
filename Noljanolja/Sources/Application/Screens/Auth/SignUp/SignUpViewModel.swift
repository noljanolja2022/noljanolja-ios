//
//  SignUpViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/02/2023.
//
//

import Combine

// MARK: - SignUpViewModelDelegate

protocol SignUpViewModelDelegate: AnyObject {
    func updateSignUpStep(_ step: SignUpStep)
}

// MARK: - SignUpViewModelType

protocol SignUpViewModelType: ObservableObject, EmailVerificationViewModelDelegate {
    // MARK: State

    var email: String { get set }
    var password: String { get set }
    var confirmPassword: String { get set }

    var emailErrorMessage: String? { get set }
    var passwordErrorMessage: String? { get set }
    var confirmPasswordErrorMessage: String? { get set }

    var isSignUpButtonEnabled: Bool { get set }

    var isProgressHUDShowingPublisher: Published<Bool>.Publisher { get }

    var isAlertMessagePresented: Bool { get set }
    var alertMessage: String { get set }

    var isShowingEmailVerificationView: Bool { get set }

    // MARK: Action

    var signUpTrigger: PassthroughSubject<(String, String), Never> { get }
    var updateSignUpStepTrigger: PassthroughSubject<SignUpStep, Never> { get }
}

// MARK: - SignUpViewModel

final class SignUpViewModel: SignUpViewModelType {
    // MARK: Dependencies

    private weak var delegate: SignUpViewModelDelegate?
    private let authServices: AuthServicesType

    // MARK: State

    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    @Published var emailErrorMessage: String? = nil
    @Published var passwordErrorMessage: String? = nil
    @Published var confirmPasswordErrorMessage: String? = nil

    @Published var isSignUpButtonEnabled = false

    @Published private var isProgressHUDShowing = false
    var isProgressHUDShowingPublisher: Published<Bool>.Publisher { $isProgressHUDShowing }

    @Published var isAlertMessagePresented = false
    @Published var alertMessage = ""

    @Published var isShowingEmailVerificationView = false

    // MARK: Action

    let signUpTrigger = PassthroughSubject<(String, String), Never>()
    let updateSignUpStepTrigger = PassthroughSubject<SignUpStep, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: SignUpViewModelDelegate? = nil,
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
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMap { [weak self] email, password -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signUp(email: email, password: password)
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                self?.isProgressHUDShowing = false
                switch result {
                case let .success(idToken):
                    logger.info("Signed up with Email/Password - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign up with Email/Password failed: \(error.localizedDescription)")

                    switch error {
                    case FirebaseAuthError.emailNotVerified as FirebaseAuthError:
                        self?.isShowingEmailVerificationView = true
                        self?.updateSignUpStepTrigger.send(.third)
                    default:
                        self?.isAlertMessagePresented = true
                        self?.alertMessage = L10n.Common.Error.message
                    }
                }
            })
            .store(in: &cancellables)

        updateSignUpStepTrigger
            .sink { [weak self] in self?.delegate?.updateSignUpStep($0) }
            .store(in: &cancellables)
    }
}

// MARK: EmailVerificationViewModelDelegate

extension SignUpViewModel: EmailVerificationViewModelDelegate {
    func updateSignUpStep(_ step: SignUpStep) {
        delegate?.updateSignUpStep(step)
    }
}
