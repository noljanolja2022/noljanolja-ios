//
//  AuthServices.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import Combine
import FirebaseAuth
import FirebaseAuthCombineSwift
import Foundation

// MARK: - AuthServicesType

protocol AuthServicesType {
    func signInWithApple() -> AnyPublisher<String, Error>
    func signInWithGoogle() -> AnyPublisher<String, Error>
    func signInWithKakao() -> AnyPublisher<String, Error>
    func signInWithNaver() -> AnyPublisher<String, Error>
    func signOut() -> AnyPublisher<Void, Error>
}

// MARK: - AuthServices

final class AuthServices: NSObject, AuthServicesType {
    private lazy var appleAuthAPI = AppleAuthAPI()
    private lazy var googleAuthAPI = GoogleAuthAPI()
    private lazy var kakaoAuthAPI = KakaoAuthAPI()
    private lazy var naverAuthAPI = NaverAuthAPI()
    private lazy var cloudFunctionAuthAPI = CloudFunctionAuthAPI()
    private lazy var authStore = AuthStore.default

    func signInWithApple() -> AnyPublisher<String, Error> {
        appleAuthAPI.signIn()
            .flatMap {
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: $0.0, rawNonce: $0.1)
                return Auth.auth().signIn(with: credential)
            }
            .flatMap {
                $0.user.getIDTokenResult()
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.authStore.saveToken($0)
            })
            .eraseToAnyPublisher()
    }

    func signInWithGoogle() -> AnyPublisher<String, Error> {
        googleAuthAPI.signIn()
            .flatMap {
                let credential = GoogleAuthProvider.credential(withIDToken: $0.0, accessToken: $0.1)
                return Auth.auth().signIn(with: credential)
            }
            .flatMap {
                $0.user.getIDTokenResult()
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.authStore.saveToken($0)
            })
            .eraseToAnyPublisher()
    }

    func signInWithKakao() -> AnyPublisher<String, Error> {
        kakaoAuthAPI.signIn()
            .flatMap { [weak self] in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.cloudFunctionAuthAPI.authWithKakao(token: $0)
            }
            .flatMap {
                Auth.auth().signIn(withCustomToken: $0)
            }
            .flatMap {
                $0.user.getIDTokenResult()
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.authStore.saveToken($0)
            })
            .eraseToAnyPublisher()
    }

    func signInWithNaver() -> AnyPublisher<String, Error> {
        naverAuthAPI.signIn().eraseToAnyPublisher()
            .flatMap { [weak self] in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.cloudFunctionAuthAPI.authWithNaver(token: $0)
            }
            .flatMap {
                Auth.auth().signIn(withCustomToken: $0)
            }
            .flatMap {
                $0.user.getIDTokenResult()
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.authStore.saveToken($0)
            })
            .eraseToAnyPublisher()
    }

    func signOut() -> AnyPublisher<Void, Error> {
        Publishers.CombineLatest4(
            appleAuthAPI.signOutIfNeeded(),
            googleAuthAPI.signOutIfNeeded(),
            kakaoAuthAPI.signOutIfNeeded(),
            naverAuthAPI.signOutIfNeeded()
        )
        .flatMap { _ in
            Auth.auth().signOutCombine()
        }
        .handleEvents(receiveOutput: { [weak self] in
            self?.authStore.clearToken()
        })
        .eraseToAnyPublisher()
    }
}
