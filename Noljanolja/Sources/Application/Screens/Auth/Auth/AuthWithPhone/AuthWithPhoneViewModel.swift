//
//  AuthWithPhoneViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import Combine

// MARK: - AuthWithPhoneViewModelDelegate

protocol AuthWithPhoneViewModelDelegate: AnyObject {}

// MARK: - AuthWithPhoneViewModelType

protocol AuthWithPhoneViewModelType: ObservableObject, SelectCountryViewModelDelegate {
    // MARK: State

    var country: Country { get set }

    var phoneNumber: String { get set }
    var phoneNumberErrorMessage: String? { get set }

    var isShowingProgressHUDPublisher: Published<Bool>.Publisher { get }

    var isSignInButtonEnabled: Bool { get set }
    var isAlertMessagePresented: Bool { get set }
    var alertMessage: String { get set }

    var isShowingSelectPhoneNumbers: Bool { get set }
    var verificationID: String? { get set }

    // MARK: Action

    var sendPhoneVerificationCodeTrigger: PassthroughSubject<String, Never> { get }
    var signInWithGoogleTrigger: PassthroughSubject<Void, Never> { get }
}

// MARK: - AuthWithPhoneViewModel

final class AuthWithPhoneViewModel: AuthWithPhoneViewModelType {
    // MARK: Dependencies

    private weak var delegate: AuthWithPhoneViewModelDelegate?
    private let authServices: AuthServicesType

    // MARK: State

    @Published var country = Country.default

    @Published var phoneNumber = ""
    @Published var phoneNumberErrorMessage: String? = nil

    @Published var isSignInButtonEnabled = true

    @Published private var isShowingProgressHUD = false
    var isShowingProgressHUDPublisher: Published<Bool>.Publisher { $isShowingProgressHUD }

    @Published var isAlertMessagePresented = false
    @Published var alertMessage = ""

    @Published var isShowingSelectPhoneNumbers = false
    @Published var verificationID: String? = nil

    // MARK: Action

    let sendPhoneVerificationCodeTrigger = PassthroughSubject<String, Never>()
    let signInWithGoogleTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: AuthWithPhoneViewModelDelegate? = nil,
         authServices: AuthServicesType = AuthServices.default) {
        self.delegate = delegate
        self.authServices = authServices

        configure()
    }

    private func configure() {
        signInWithGoogleTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.isShowingProgressHUD = true })
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signInWithGoogle()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                self?.isShowingProgressHUD = false
                switch result {
                case let .success(idToken):
                    logger.info("Signed in with Google successful - Token: \(idToken)")
                case let .failure(error):
                    logger.error("Sign in with Google failed: \(error.localizedDescription)")
                    self?.isAlertMessagePresented = true
                    self?.alertMessage = L10n.Common.Error.message
                }
            })
            .store(in: &cancellables)

        sendPhoneVerificationCodeTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.isShowingProgressHUD = true })
            .flatMap { [weak self] phoneNumber -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                let phoneNumber = "+\(self.country.phoneCode)\(phoneNumber)"
                logger.info("Send phone number verification code: \(phoneNumber)")
                return self.authServices
                    .sendPhoneVerificationCode(phoneNumber, languageCode: self.country.nameCode)
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isShowingProgressHUD = false
                switch result {
                case let .success(verificationID):
                    logger.info("Send phone number verification code successful - VerificationID: \(verificationID)")
                    self.verificationID = verificationID
                case let .failure(error):
                    logger.error("Send phone number verification code failed: \(error.localizedDescription)")
                    self.isAlertMessagePresented = true
                    self.alertMessage = L10n.Common.Error.message
                }
            })
            .store(in: &cancellables)
    }
}

// MARK: SelectCountryViewModelDelegate

extension AuthWithPhoneViewModel: SelectCountryViewModelDelegate {
    func didSelectCountry(_ country: Country) {
        self.country = country
    }
}
