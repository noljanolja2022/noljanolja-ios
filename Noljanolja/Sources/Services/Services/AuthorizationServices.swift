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
    private lazy var appleAuthorizationAPI = AppleAuthorizationAPI()
    private lazy var googleAuthorizationAPI = GoogleAuthorizationAPI()
    private lazy var kakaoAuthorizationAPI = KakaoAuthorizationAPI()
    private lazy var naverAuthorizationAPI = NaverAuthorizationAPI()
    private lazy var cloudFunctionAuthorizationAPI = CloudFunctionAuthorizationAPI()

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
        kakaoAuthorizationAPI.signIn()
            .flatMap { [weak self] in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.cloudFunctionAuthorizationAPI.authWithKakao(token: $0)
            }
            .flatMap {
                Auth.auth().signIn(withCustomToken: $0)
            }
            .flatMap {
                $0.user.getIDTokenResult()
            }
            .eraseToAnyPublisher()
    }

    func signInWithNaver() -> AnyPublisher<String, Error> {
        naverAuthorizationAPI.signIn().eraseToAnyPublisher()
            .flatMap { [weak self] in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.cloudFunctionAuthorizationAPI.authWithNaver(token: $0)
            }
            .flatMap {
                Auth.auth().signIn(withCustomToken: $0)
            }
            .flatMap {
                $0.user.getIDTokenResult()
            }
            .eraseToAnyPublisher()
    }
}
