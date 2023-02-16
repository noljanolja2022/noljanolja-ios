//
//  EmailVerificationViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/02/2023.
//
//

import Combine

// MARK: - EmailVerificationViewModelDelegate

protocol EmailVerificationViewModelDelegate: AnyObject {
    func updateSignUpStep(_ step: SignUpStep)
}

// MARK: - EmailVerificationViewModelType

protocol EmailVerificationViewModelType: ObservableObject {
    // MARK: State

    var isProgressHUDShowingPublisher: Published<Bool>.Publisher { get }

    // MARK: Action

    var updateSignUpStepTrigger: PassthroughSubject<SignUpStep, Never> { get }
    var sendEmailVerificationTrigger: PassthroughSubject<Void, Never> { get }
    var checkEmailVerificationTrigger: PassthroughSubject<Void, Never> { get }
}

// MARK: - EmailVerificationViewModel

final class EmailVerificationViewModel: EmailVerificationViewModelType {
    // MARK: Dependencies

    private weak var delegate: EmailVerificationViewModelDelegate?
    private let authServices: AuthServicesType

    // MARK: State

    @Published private var isProgressHUDShowing = false
    var isProgressHUDShowingPublisher: Published<Bool>.Publisher { $isProgressHUDShowing }

    // MARK: Action

    let updateSignUpStepTrigger = PassthroughSubject<SignUpStep, Never>()
    let sendEmailVerificationTrigger = PassthroughSubject<Void, Never>()
    let checkEmailVerificationTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: EmailVerificationViewModelDelegate? = nil,
         authServices: AuthServicesType = AuthServices.default) {
        self.delegate = delegate
        self.authServices = authServices
        
        configure()
    }

    private func configure() {
        sendEmailVerificationTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMap { [weak self] _ -> AnyPublisher<Result<Void, Error>, Never> in
                guard let self else { return Empty<Result<Void, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .sendEmailVerification()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                self?.isProgressHUDShowing = false
                switch result {
                case .success:
                    logger.info("Send email verification successful")
                case let .failure(error):
                    logger.error("Send email verification failed: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)

        checkEmailVerificationTrigger
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMap { [weak self] _ -> AnyPublisher<Result<String, Error>, Never> in
                guard let self else { return Empty<Result<String, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .verifyEmail()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                self?.isProgressHUDShowing = false
                switch result {
                case .success:
                    logger.info("Verify email successful")
                case let .failure(error):
                    logger.error("Verify email failed: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)

        updateSignUpStepTrigger
            .sink(receiveValue: { [weak self] in self?.delegate?.updateSignUpStep($0) })
            .store(in: &cancellables)
    }
}
