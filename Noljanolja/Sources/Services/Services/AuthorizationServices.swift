//
//  AuthorizationServices.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import FirebaseAuth
import Foundation
import GoogleSignIn
import KakaoSDKUser
import NaverThirdPartyLogin

// MARK: - AuthorizationServicesType

protocol AuthorizationServicesType {
    func loginWithGoogle()
    func loginWithKakao()
    func loginWithNaver()
}

// MARK: - AuthorizationServices

final class AuthorizationServices: NSObject, AuthorizationServicesType {
    private let naverLoginConnection = NaverThirdPartyLoginConnection.getSharedInstance()

    func loginWithGoogle() {
        guard let rootViewController = UIApplication.shared.rootKeyWindow?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error {
                // ...
                return
            }

            guard let idToken = result?.user.idToken?.tokenString, let accessToken = result?.user.accessToken.tokenString else { return }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: accessToken
            )

            Auth.auth().signIn(with: credential) { _, error in
                if let error {
                    // ...
                    return
                }
                print("loginWithGoogle() success.")
            }
        }
    }

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
