//
//  SignInViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import Combine
import Foundation

// MARK: - SignInViewModelDelegate

protocol SignInViewModelDelegate: AnyObject {
    func routeToResetPassword()
}

// MARK: - SignInViewModelType

protocol SignInViewModelType: ObservableObject {
    // MARK: State

    var email: String { get set }
    var password: String { get set }

    var emailErrorMessage: String? { get set }
    var passwordErrorMessage: String? { get set }

    var isProgressHUDShowingPublisher: Published<Bool>.Publisher { get }

    var isSignInButtonEnabled: Bool { get set }
    var isAlertMessagePresented: Bool { get set }
    var alertMessage: String { get set }

    var isShowingEmailVerificationView: Bool { get set }

    // MARK: Action

    var forgotPasswordTrigger: PassthroughSubject<Void, Never> { get }
    var signInWithEmailPasswordTrigger: PassthroughSubject<(String, String), Never> { get }
    var signInWithAppleTrigger: PassthroughSubject<Void, Never> { get }
    var signInWithGoogleTrigger: PassthroughSubject<Void, Never> { get }
    var signInWithKakaoTrigger: PassthroughSubject<Void, Never> { get }
    var signInWithNaverTrigger: PassthroughSubject<Void, Never> { get }
}

// MARK: - SignInViewModel

final class SignInViewModel: SignInViewModelType {
    // MARK: Dependencies

    private weak var delegate: SignInViewModelDelegate?
    private let authServices: AuthServicesType

    // MARK: State

    @Published var email = ""
    @Published var password = ""

    @Published var emailErrorMessage: String? = nil
    @Published var passwordErrorMessage: String? = nil

    @Published var isSignInButtonEnabled = false

    @Published private var isProgressHUDShowing = false
    var isProgressHUDShowingPublisher: Published<Bool>.Publisher { $isProgressHUDShowing }

    @Published var isAlertMessagePresented = false
    @Published var alertMessage = ""

    @Published var isShowingEmailVerificationView = false

    // MARK: Action

    let forgotPasswordTrigger = PassthroughSubject<Void, Never>()
    let signInWithEmailPasswordTrigger = PassthroughSubject<(String, String), Never>()
    let signInWithAppleTrigger = PassthroughSubject<Void, Never>()
    let signInWithGoogleTrigger = PassthroughSubject<Void, Never>()
    let signInWithKakaoTrigger = PassthroughSubject<Void, Never>()
    let signInWithNaverTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: SignInViewModelDelegate? = nil,
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

        let passwordValidateResult = $password
            .removeDuplicates()
            .dropFirst()
            .map { StringValidator.validatePassword($0) }
            .handleEvents(receiveOutput: { [weak self] result in
                self?.passwordErrorMessage = result?.message
            })

        Publishers.CombineLatest(emailValidateResult, passwordValidateResult)
            .sink(receiveValue: { [weak self] emailValidateResult, passwordValidateResult in
                self?.isSignInButtonEnabled = emailValidateResult == nil && passwordValidateResult == nil
            })
            .store(in: &cancellables)

        signInWithEmailPasswordTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMap { [weak self] email, password -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signIn(email: email, password: password)
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                self?.isProgressHUDShowing = false
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Email/Password - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Email/Password failed: \(error.localizedDescription)")

                    switch error {
                    case FirebaseAuthError.emailNotVerified as FirebaseAuthError:
                        self?.isShowingEmailVerificationView = true
                    default:
                        self?.isAlertMessagePresented = true
                        self?.alertMessage = L10n.Common.Error.message
                    }
                }
            })
            .store(in: &cancellables)

        signInWithAppleTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithApple()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                self?.isProgressHUDShowing = false
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Apple - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Apple failed: \(error.localizedDescription)")
                    self?.isAlertMessagePresented = true
                    self?.alertMessage = L10n.Common.Error.message
                }
            })
            .store(in: &cancellables)

        signInWithGoogleTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithGoogle()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                self?.isProgressHUDShowing = false
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Google - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Google failed: \(error.localizedDescription)")
                    self?.isAlertMessagePresented = true
                    self?.alertMessage = L10n.Common.Error.message
                }
            }
            )
            .store(in: &cancellables)

        signInWithKakaoTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithKakao()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                self?.isProgressHUDShowing = false
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Kakao - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Kakao failed: \(error.localizedDescription)")
                    self?.isAlertMessagePresented = true
                    self?.alertMessage = L10n.Common.Error.message
                }
            })
            .store(in: &cancellables)

        signInWithNaverTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithNaver { [weak self] in
                        self?.isProgressHUDShowing = true
                    }
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                self?.isProgressHUDShowing = false
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Naver - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Naver failed: \(error.localizedDescription)")
                    self?.isAlertMessagePresented = true
                    self?.alertMessage = L10n.Common.Error.message
                }
            }
            )
            .store(in: &cancellables)

        forgotPasswordTrigger
            .sink { [weak self] in self?.delegate?.routeToResetPassword() }
            .store(in: &cancellables)
    }
}
