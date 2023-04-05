//
//  AuthWithPhoneViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import Combine
import SwiftUINavigation

// MARK: - AuthWithPhoneViewModelDelegate

protocol AuthWithPhoneViewModelDelegate: AnyObject {
    func navigateToMain()
    func navigateToUpdateCurrentUser()
}

// MARK: - AuthWithPhoneViewModelType

protocol AuthWithPhoneViewModelType: SelectCountryViewModelDelegate,
    PhoneVerificationCodeViewModelDelegate,
    ViewModelType where State == AuthWithPhoneViewModel.State, Action == AuthWithPhoneViewModel.Action {}

extension AuthWithPhoneViewModel {
    struct State {
        var phoneNumber = ""
        var country = CountryAPI().getDefaultCountry()
        var fullPhoneNumber: String {
            "+\(country.phoneCode)\(phoneNumber)"
        }

        var isSignInButtonEnabled: Bool {
            !phoneNumber.isEmpty
        }

        var verificationID: String?
        var isProgressHUDShowing = false
        var alertState: AlertState<Bool>?
    }

    enum Action {
        case showConfirmPhoneAlert
        case sendVerificationCode
    }
}

// MARK: - AuthWithPhoneViewModel

final class AuthWithPhoneViewModel: AuthWithPhoneViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private let authService: AuthServiceType
    private weak var delegate: AuthWithPhoneViewModelDelegate?

    // MARK: Action

    private let sendVerificationCodeTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         authService: AuthServiceType = AuthService.default,
         delegate: AuthWithPhoneViewModelDelegate? = nil) {
        self.state = state
        self.authService = authService
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .showConfirmPhoneAlert:
            state.alertState = AlertState(
                title: TextState(state.fullPhoneNumber),
                message: TextState("You will receive a code to verify to this phone number via text message."),
                primaryButton: .destructive(TextState("Cancel")),
                secondaryButton: .default(TextState("Confirm"), action: .send(true))
            )
        case .sendVerificationCode:
            sendVerificationCodeTrigger.send()
        }
    }

    private func configure() {
        sendVerificationCodeTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.state.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<String, Error> in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                logger.info("Send verification code to phone: \(self.state.fullPhoneNumber)")
                return self.authService
                    .sendPhoneVerificationCode(self.state.fullPhoneNumber, languageCode: self.state.country.code)
            }
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.state.isProgressHUDShowing = false
                switch result {
                case let .success(verificationID):
                    logger.info("Send verification code successful - VerificationID: \(verificationID)")
                    self.state.verificationID = verificationID
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
    }
}

// MARK: SelectCountryViewModelDelegate

extension AuthWithPhoneViewModel: SelectCountryViewModelDelegate {
    func didSelectCountry(_ country: Country) {
        state.country = country
    }
}

// MARK: PhoneVerificationCodeViewModelDelegate

extension AuthWithPhoneViewModel: PhoneVerificationCodeViewModelDelegate {
    func navigateToMain() {
        delegate?.navigateToMain()
    }

    func navigateToUpdateCurrentUser() {
        delegate?.navigateToUpdateCurrentUser()
    }
}
