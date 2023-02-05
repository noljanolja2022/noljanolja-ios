//
//  AuthorizationServices.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import Combine
import FirebaseAuth
import FirebaseAuthCombineSwift
import Foundation

// MARK: - AuthorizationServicesType

protocol AuthorizationServicesType {
    func signInWithApple() -> AnyPublisher<String, Error>
    func signInWithGoogle() -> AnyPublisher<String, Error>
    func signInWithKakao() -> AnyPublisher<String, Error>
    func signInWithNaver() -> AnyPublisher<String, Error>
}

// MARK: - AuthorizationServices

final class AuthorizationServices: NSObject, AuthorizationServicesType {
    private let appleAuthorizationAPI = AppleAuthorizationAPI()
    private let googleAuthorizationAPI = GoogleAuthorizationAPI()
    private let kakaoAuthorizationAPI = KakaoAuthorizationAPI()
    private let naverAuthorizationAPI = NaverAuthorizationAPI()

    func signInWithApple() -> AnyPublisher<String, Error> {
        appleAuthorizationAPI.signIn()
            .flatMap {
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: $0.0, rawNonce: $0.1)
                return Auth.auth().signIn(with: credential)
            }
            .flatMap {
                $0.user.getIDTokenResult()
            }
            .eraseToAnyPublisher()
    }

    func signInWithGoogle() -> AnyPublisher<String, Error> {
        googleAuthorizationAPI.signIn()
            .flatMap {
                let credential = GoogleAuthProvider.credential(withIDToken: $0.0, accessToken: $0.1)
                return Auth.auth().signIn(with: credential)
            }
            .flatMap {
                $0.user.getIDTokenResult()
            }
            .eraseToAnyPublisher()
    }

    func signInWithKakao() -> AnyPublisher<String, Error> {
        kakaoAuthorizationAPI.signIn().eraseToAnyPublisher()
    }

    func signInWithNaver() -> AnyPublisher<String, Error> {
        naverAuthorizationAPI.signIn().eraseToAnyPublisher()
    }
}
