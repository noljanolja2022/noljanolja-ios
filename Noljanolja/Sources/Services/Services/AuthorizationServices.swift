//
//  AuthorizationServices.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import Foundation
import KakaoSDKUser

// MARK: - AuthorizationServicesType

protocol AuthorizationServicesType {
    func loginWithKakaoAccount()
}

// MARK: - AuthorizationServices

final class AuthorizationServices: AuthorizationServicesType {
    func loginWithKakaoAccount() {
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
}
