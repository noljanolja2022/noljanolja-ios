//
//  NaverAuthRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/02/2023.
//

import Combine
import Foundation
import NaverThirdPartyLogin

// MARK: - NaverAuthRepository

final class NaverAuthRepository: NSObject {
    private lazy var naverLoginConnection = NaverThirdPartyLoginConnection.getSharedInstance()

    private let successTrigger = PassthroughSubject<String, Never>()
    private let failTrigger = PassthroughSubject<Error, Never>()
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()

        naverLoginConnection?.delegate = self
    }

    func signIn() -> Future<String, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            self.naverLoginConnection?.requestThirdPartyLogin()
            self.successTrigger
                .sink { promise(.success($0)) }
                .store(in: &self.cancellables)
            self.failTrigger
                .sink { promise(.failure($0)) }
                .store(in: &self.cancellables)
        }
    }

    func signOutIfNeeded() -> Future<Void, Error> {
        Future { [weak self] promise in
            if self?.naverLoginConnection?.accessToken != nil {
                self?.naverLoginConnection?.requestDeleteToken()
                self?.naverLoginConnection?.resetToken()
                self?.naverLoginConnection?.removeNaverLoginCookie()
            }
            promise(.success(()))
        }
    }
}

// MARK: NaverThirdPartyLoginConnectionDelegate

extension NaverAuthRepository: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        if let accessToken = naverLoginConnection?.accessToken {
            successTrigger.send(accessToken)
        } else {
            failTrigger.send(NaverAuthError.tokenNotExit)
        }
    }

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        if let accessToken = naverLoginConnection?.accessToken {
            successTrigger.send(accessToken)
        } else {
            failTrigger.send(NaverAuthError.tokenNotExit)
        }
    }

    func oauth20ConnectionDidFinishDeleteToken() {}

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        failTrigger.send(error)
    }
}
