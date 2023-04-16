//
//  AuthViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import Combine
import SwiftUINavigation

// MARK: - AuthViewModelDelegate

protocol AuthViewModelDelegate: AnyObject {
    func navigateToMain()
    func navigateToUpdateCurrentUser()
}

// MARK: - AuthViewModel

final class AuthViewModel: ViewModel {
    // MARK: State

    @Published var country = CountryAPI().getDefaultCountry()
    @Published var phoneNumberText = ""
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Bool>?

    var verificationID: String?

    var phoneNumber: String? {
        "+\(country.phoneCode)\(phoneNumberText)"
    }

    // MARK: Navigations

    @Published var fullScreenCoverType: AuthFullScreenCoverType?

    // MARK: Action

    let sendVerificationCodeAction = PassthroughSubject<(String, String?), Never>()

    // MARK: Dependencies

    private let authService: AuthServiceType
    private weak var delegate: AuthViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthServiceType = AuthService.default,
         delegate: AuthViewModelDelegate? = nil) {
        self.authService = authService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        sendVerificationCodeAction
            .compactMap { countryCode, phoneNumber in phoneNumber.flatMap { (countryCode, $0) } }
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] countryCode, phoneNumber -> AnyPublisher<String, Error> in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                logger.info("Send verification code to phone: \(phoneNumber)")
                return self.authService
                    .sendPhoneVerificationCode(phoneNumber, languageCode: countryCode)
            }
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(verificationID):
                    logger.info("Send verification code successful - VerificationID: \(verificationID)")
                    self.verificationID = verificationID
                case let .failure(error):
                    logger.error("Send verification code failed: \(error.localizedDescription)")
                    self.alertState = AlertState(
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

extension AuthViewModel: SelectCountryViewModelDelegate {
    func didSelectCountry(_ country: Country) {
        self.country = country
    }
}

// MARK: AuthVerificationViewModelDelegate

extension AuthViewModel: AuthVerificationViewModelDelegate {
    func navigateToMain() {
        delegate?.navigateToMain()
    }

    func navigateToUpdateCurrentUser() {
        delegate?.navigateToUpdateCurrentUser()
    }
}
