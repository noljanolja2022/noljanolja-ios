//
//  AuthViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import Combine
import SwiftUINavigation
import SwiftUIX

// MARK: - AuthViewModelDelegate

protocol AuthViewModelDelegate: AnyObject {
    func authViewModelDidComplete(_ user: User)
}

// MARK: - AuthViewModel

final class AuthViewModel: ViewModel {
    // MARK: State

    @Published var country = CountryRepositoryImpl().getDefaultCountry()
    @Published var phoneNumberText = ""
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Bool>?

    var verificationID: String?

    var phoneNumber: String? {
        "\(country.prefix)\(phoneNumberText)"
    }

    // MARK: Navigations

    @Published var fullScreenCoverType: AuthFullScreenCoverType?

    // MARK: Action

    let sendVerificationCodeAction = PassthroughSubject<(String, String?), Never>()

    // MARK: Dependencies

    private let authUseCases: AuthUseCases
    private weak var delegate: AuthViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(authUseCases: AuthUseCases = AuthUseCasesImpl.default,
         delegate: AuthViewModelDelegate? = nil) {
        self.authUseCases = authUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        isAppearSubject
            .filter { !$0 }
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isProgressHUDShowing = false
            }
            .store(in: &cancellables)

        sendVerificationCodeAction
            .compactMap { countryCode, phoneNumber in phoneNumber.flatMap { (countryCode, $0) } }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] countryCode, phoneNumber -> AnyPublisher<String, Error> in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.authUseCases
                    .sendPhoneVerificationCode(phoneNumber, languageCode: countryCode)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(verificationID):
                    self.verificationID = verificationID
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)
    }
}

// MARK: SelectCountryViewModelDelegate

extension AuthViewModel: SelectCountryViewModelDelegate {
    func selectCountryViewModel(didSelectCountry country: Country) {
        self.country = country
    }
}

// MARK: AuthVerificationViewModelDelegate

extension AuthViewModel: AuthVerificationViewModelDelegate {
    func authVerificationViewModelDidComplete(_ user: User) {
        delegate?.authViewModelDidComplete(user)
    }
}
