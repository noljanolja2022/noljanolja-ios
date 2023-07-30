//
//  AuthVerificationViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import Combine
import Foundation
import SwiftUINavigation

// MARK: - AuthVerificationViewModelDelegate

protocol AuthVerificationViewModelDelegate: AnyObject {
    func navigateToMain()
    func navigateToUpdateCurrentUser()
}

// MARK: - AuthVerificationViewModel

final class AuthVerificationViewModel: ViewModel {
    // MARK: State

    @Published var verificationCode = ""
    @Published var countdownResendCodeTime = 0
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    var phoneNumber: String {
        "\(country.prefix)\(phoneNumberText)"
    }

    // MARK: Action

    let resendCodeAction = PassthroughSubject<(String, String?), Never>()
    let verifyAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let country: Country
    let phoneNumberText: String
    
    private var verificationID: String

    private let authService: AuthServiceType
    private let userService: UserServiceType
    private weak var delegate: AuthVerificationViewModelDelegate?

    // MARK: Private

    private let resendCodeDuration = 90
    private var resendCodeCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()

    init(country: Country,
         phoneNumberText: String,
         verificationID: String,
         authService: AuthServiceType = AuthService.default,
         userService: UserServiceType = UserService.default,
         delegate: AuthVerificationViewModelDelegate? = nil) {
        self.country = country
        self.phoneNumberText = phoneNumberText
        self.verificationID = verificationID
        self.authService = authService
        self.userService = userService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        resendCodeAction
            .compactMap { countryCode, phoneNumber in phoneNumber.flatMap { (countryCode, $0) } }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] countryCode, phoneNumber -> AnyPublisher<String, Error> in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.authService
                    .sendPhoneVerificationCode(phoneNumber, languageCode: countryCode)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(verificationID):
                    self.verificationID = verificationID
                    self.startCountdownResendCodeTime()
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)

        verifyAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<User, Error> in
                guard let self else {
                    return Empty<User, Error>().eraseToAnyPublisher()
                }
                return self.authService
                    .verificationCode(verificationID: self.verificationID, verificationCode: self.verificationCode)
                    .flatMap { _ in
                        self.userService.getCurrentUser()
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                self?.isProgressHUDShowing = false
                switch result {
                case let .success(user):
                    if user.isSettedUp {
                        self?.delegate?.navigateToMain()
                    } else {
                        self?.delegate?.navigateToUpdateCurrentUser()
                    }
                case .failure:
                    self?.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)

        startCountdownResendCodeTime()
    }

    private func startCountdownResendCodeTime() {
        countdownResendCodeTime = resendCodeDuration
        resendCodeCancellable = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                self.countdownResendCodeTime -= 1
                if self.countdownResendCodeTime == 0 {
                    self.resendCodeCancellable = nil
                }
            })
    }
}
