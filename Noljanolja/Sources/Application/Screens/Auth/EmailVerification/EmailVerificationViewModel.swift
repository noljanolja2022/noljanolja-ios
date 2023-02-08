//
//  EmailVerificationViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import Combine

final class EmailVerificationViewModel: ObservableObject {
    // MARK: Dependencies

    private let authServices: AuthServicesType

    // MARK: Input

    let sendEmailVerificationTrigger = PassthroughSubject<Void, Never>()

    // MARK: Output

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(authServices: AuthServicesType = AuthServices.default) {
        self.authServices = authServices

        configure()
    }

    private func configure() {
        sendEmailVerificationTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<Void, Error>, Never> in
                guard let self else { return Empty<Result<Void, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .sendEmailVerification()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { result in
                switch result {
                case .success:
                    logger.info("Send email verification successfull")
                case let .failure(error):
                    logger.error("Send email verification failed: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)
    }
}
