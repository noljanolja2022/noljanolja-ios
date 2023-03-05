//
//  PhoneVerificationCodeViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import Combine
import Foundation
import SwiftUINavigation

// MARK: - PhoneVerificationCodeViewModelDelegate

protocol PhoneVerificationCodeViewModelDelegate: AnyObject {
    func navigateToMain()
    func navigateToUpdateProfile()
}

// MARK: - PhoneVerificationCodeViewModelType

protocol PhoneVerificationCodeViewModelType:
    ViewModelType where State == PhoneVerificationCodeViewModel.State, Action == PhoneVerificationCodeViewModel.Action {}

extension PhoneVerificationCodeViewModel {
    struct State {
        fileprivate let country: Country
        fileprivate let phoneNumber: String
        var fullPhoneNumber: String {
            "+\(country.phoneCode)\(phoneNumber)"
        }

        var verificationCode = ""
        var countdownResendCodeTime = 0
        var isProgressHUDShowing = false
        var alertState: AlertState<Void>?

        init(country: Country, phoneNumber: String) {
            self.country = country
            self.phoneNumber = phoneNumber
        }
    }

    enum Action {
        case resendCode
        case startResendCodeCountdownTime
        case verifyCode
    }
}

// MARK: - PhoneVerificationCodeViewModel

final class PhoneVerificationCodeViewModel: PhoneVerificationCodeViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private var verificationID: String
    private let authServices: AuthServicesType
    private let profileService: ProfileServiceType
    private weak var delegate: PhoneVerificationCodeViewModelDelegate?

    // MARK: Action

    private let resendCodeTrigger = PassthroughSubject<Void, Never>()
    private let verifyTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private let resendCodeDuration = 90
    private var resendCodeCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()

    init(state: State,
         verificationID: String,
         authServices: AuthServicesType = AuthServices.default,
         profileService: ProfileServiceType = ProfileService.default,
         delegate: PhoneVerificationCodeViewModelDelegate? = nil) {
        self.state = state
        self.verificationID = verificationID
        self.authServices = authServices
        self.profileService = profileService
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .resendCode:
            resendCodeTrigger.send()
        case .startResendCodeCountdownTime:
            startCountdownResendCodeTime()
        case .verifyCode:
            verifyTrigger.send()
        }
    }

    private func configure() {
        resendCodeTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.state.isProgressHUDShowing = true })
            .flatMap { [weak self] _ -> AnyPublisher<String, Error> in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                logger.info("Send verification code to phone: \(self.state.fullPhoneNumber)")
                return self.authServices
                    .sendPhoneVerificationCode(self.state.fullPhoneNumber, languageCode: self.state.country.code)
            }
            .eraseToResultAnyPublisher()
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.state.isProgressHUDShowing = false
                switch result {
                case let .success(verificationID):
                    logger.info("Send verification code successful - VerificationID: \(verificationID)")
                    self.verificationID = verificationID
                    self.send(.startResendCodeCountdownTime)
                case let .failure(error):
                    logger.error("Send verification code failed: \(error.localizedDescription)")
                    self.state.alertState = AlertState(
                        title: TextState("Error"),
                        message: TextState(L10n.Common.Error.message),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)

        verifyTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.state.isProgressHUDShowing = true })
            .flatMap { [weak self] _ -> AnyPublisher<String, Error> in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.authServices
                    .verificationCode(verificationID: self.verificationID, verificationCode: self.state.verificationCode)
            }
            .flatMap { [weak self] _ -> AnyPublisher<ProfileModel, Error> in
                guard let self else {
                    return Empty<ProfileModel, Error>().eraseToAnyPublisher()
                }
                return self.profileService.getProfile()
            }
            .eraseToResultAnyPublisher()
            .sink(receiveValue: { [weak self] result in
                self?.state.isProgressHUDShowing = false
                switch result {
                case let .success(profileModel):
                    logger.info("Verify verification code successful")
                    if profileModel.isSetup {
                        self?.delegate?.navigateToMain()
                    } else {
                        self?.delegate?.navigateToUpdateProfile()
                    }
                case let .failure(error):
                    logger.error("Verify verification code code failed: \(error.localizedDescription)")
                    self?.state.alertState = AlertState(
                        title: TextState("Error"),
                        message: TextState(L10n.Common.Error.message),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)

        startCountdownResendCodeTime()
    }

    private func startCountdownResendCodeTime() {
        state.countdownResendCodeTime = resendCodeDuration
        resendCodeCancellable = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                self.state.countdownResendCodeTime -= 1
                if self.state.countdownResendCodeTime == 0 {
                    self.resendCodeCancellable = nil
                }
            })
    }
}
