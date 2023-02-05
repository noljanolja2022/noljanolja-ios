//
//  NaverAuthorizationAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/02/2023.
//

import Combine
import Foundation
import NaverThirdPartyLogin

// MARK: - NaverAuthorizationAPI

final class NaverAuthorizationAPI: NSObject {
    private let naverLoginConnection = NaverThirdPartyLoginConnection.getSharedInstance()

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
}

// MARK: NaverThirdPartyLoginConnectionDelegate

extension NaverAuthorizationAPI: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        logger.info("FinishRequestACTokenWithAuthCode - \(naverLoginConnection?.accessToken ?? "")")
        if let accessToken = naverLoginConnection?.accessToken {
            successTrigger.send(accessToken)
        } else {
            failTrigger.send(NaverAuthorizationError.tokenNotExit)
        }
    }

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        logger.info("FinishRequestACTokenWithRefreshToken")
        if let accessToken = naverLoginConnection?.accessToken {
            successTrigger.send(accessToken)
        } else {
            failTrigger.send(NaverAuthorizationError.tokenNotExit)
        }
    }

    func oauth20ConnectionDidFinishDeleteToken() {
        logger.info("FinishDeleteToken")
    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        logger.info("FailWithError - \(error.debugDescription)")
        failTrigger.send(error)
    }
}
