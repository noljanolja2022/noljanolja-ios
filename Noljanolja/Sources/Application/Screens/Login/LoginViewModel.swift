//
//  LoginViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import Combine
import Foundation

extension LoginViewModel {
    struct Input {
        let googleLoginTrigger = PassthroughSubject<Void, Never>()
        let kakaoLoginTrigger = PassthroughSubject<Void, Never>()
        let naverLoginTrigger = PassthroughSubject<Void, Never>()
    }

    struct Output {}
}

// MARK: - LoginViewModel

final class LoginViewModel: ObservableObject {
    private let authorizationServices: AuthorizationServicesType

    let input = Input()
    let output = Output()

    private var cancellables = Set<AnyCancellable>()

    init(authorizationServices: AuthorizationServicesType = AuthorizationServices()) {
        self.authorizationServices = authorizationServices

        configure()
    }

    private func configure() {
        input.googleLoginTrigger
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.authorizationServices.loginWithGoogle()
                }
            )
            .store(in: &cancellables)

        input.kakaoLoginTrigger
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.authorizationServices.loginWithKakao()
                }
            )
            .store(in: &cancellables)

        input.naverLoginTrigger
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.authorizationServices.loginWithNaver()
                }
            )
            .store(in: &cancellables)
    }
}
