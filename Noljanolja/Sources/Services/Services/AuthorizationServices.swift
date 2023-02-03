//
//  AuthorizationServices.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import Foundation
import KakaoSDKUser
import NaverThirdPartyLogin

// MARK: - AuthorizationServicesType

protocol AuthorizationServicesType {
    func loginWithKakao()
    func loginWithNaver()
}

// MARK: - AuthorizationServices

final class AuthorizationServices: NSObject, AuthorizationServicesType {
    private let naverLoginConnection = NaverThirdPartyLoginConnection.getSharedInstance()

    func loginWithKakao() {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")

                // Do something
                _ = oauthToken
            }
        }
    }

    func loginWithNaver() {
        naverLoginConnection?.delegate = self
        naverLoginConnection?.requestThirdPartyLogin()
    }
}

// MARK: NaverThirdPartyLoginConnectionDelegate

extension AuthorizationServices: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("oauth20ConnectionDidFinishRequestACTokenWithAuthCode")
        print(naverLoginConnection?.accessToken)
    }

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("oauth20ConnectionDidFinishRequestACTokenWithRefreshToken")
    }

    func oauth20ConnectionDidFinishDeleteToken() {
        print("oauth20ConnectionDidFinishDeleteToken")
    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("oauth20ConnectionDidFinishDeleteToken")
    }
}
