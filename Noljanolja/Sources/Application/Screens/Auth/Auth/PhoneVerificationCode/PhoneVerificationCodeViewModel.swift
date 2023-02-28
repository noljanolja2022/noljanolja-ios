//
//  PhoneVerificationCodeViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import Combine
import Foundation

// MARK: - PhoneVerificationCodeViewModelDelegate

protocol PhoneVerificationCodeViewModelDelegate: AnyObject {}

// MARK: - PhoneVerificationCodeViewModelType

protocol PhoneVerificationCodeViewModelType: ObservableObject {
    // MARK: State

    var phoneNumber: String { get }
    var country: Country { get }
    var verificationCode: String { get set }

    var countdownResendCodeTime: Int { get set }

    var isShowingProgressHUDPublisher: Published<Bool>.Publisher { get }

    var isAlertMessagePresented: Bool { get set }
    var alertMessage: String { get set }

    // MARK: Action

    var resendCodeTrigger: PassthroughSubject<Void, Never> { get }
    var verifyTrigger: PassthroughSubject<Void, Never> { get }
}

// MARK: - PhoneVerificationCodeViewModel

final class PhoneVerificationCodeViewModel: PhoneVerificationCodeViewModelType {
    // MARK: Dependencies

    private weak var delegate: PhoneVerificationCodeViewModelDelegate?
    private let authServices: AuthServicesType
    let phoneNumber: String
    let country: Country
    private var verificationID: String

    // MARK: State

    @Published var countdownResendCodeTime = 0

    @Published var verificationCode = ""

    @Published private var isShowingProgressHUD = false
    var isShowingProgressHUDPublisher: Published<Bool>.Publisher { $isShowingProgressHUD }

    @Published var isAlertMessagePresented = false
    @Published var alertMessage = ""

    // MARK: Action

    let resendCodeTrigger = PassthroughSubject<Void, Never>()
    let verifyTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private let maxCountdownResendCodeTime = 60
    private var countdownResendCodeTimeCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()

    init(delegate: PhoneVerificationCodeViewModelDelegate? = nil,
         authServices: AuthServicesType = AuthServices.default,
         phoneNumber: String,
         country: Country,
         verificationID: String) {
        self.delegate = delegate
        self.authServices = authServices
        self.phoneNumber = phoneNumber
        self.country = country
        self.verificationID = verificationID

        configure()
    }

    private func configure() {
        resendCodeTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.isShowingProgressHUD = true })
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                let phoneNumber = "+\(self.country.phoneCode)\(self.phoneNumber)"
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
                    self.startCountdownResendCodeTime()
                case let .failure(error):
                    logger.error("Send phone number verification code failed: \(error.localizedDescription)")
                    self.isAlertMessagePresented = true
                    self.alertMessage = L10n.Common.Error.message
                }
            })
            .store(in: &cancellables)

        verifyTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.isShowingProgressHUD = true })
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .verificationCode(verificationID: self.verificationID, verificationCode: self.verificationCode)
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isShowingProgressHUD = false
                switch result {
                case let .success(token):
                    logger.info("Verify phone number successful - Token: \(token)")
                case let .failure(error):
                    logger.error("Verify phone number code failed: \(error.localizedDescription)")
                    self.isAlertMessagePresented = true
                    self.alertMessage = L10n.Common.Error.message
                }
            })
            .store(in: &cancellables)

        startCountdownResendCodeTime()
    }

    private func startCountdownResendCodeTime() {
        countdownResendCodeTime = maxCountdownResendCodeTime
        countdownResendCodeTimeCancellable = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                self.countdownResendCodeTime -= 1
                if self.countdownResendCodeTime == 0 {
                    self.countdownResendCodeTimeCancellable = nil
                }
            })
    }
}
