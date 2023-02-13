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
    var isAuthenticated: CurrentValueSubject<Bool, Never> { get set }

    func signUp(email: String, password: String) -> AnyPublisher<String, Error>
    func sendEmailVerification() -> AnyPublisher<Void, Error>
    func verifyEmail() -> AnyPublisher<String, Error>
    func sendPasswordReset(email: String) -> AnyPublisher<Void, Error>

    func signIn(email: String, password: String) -> AnyPublisher<String, Error>
    func signInWithApple() -> AnyPublisher<String, Error>
    func signInWithGoogle() -> AnyPublisher<String, Error>
    func signInWithKakao() -> AnyPublisher<String, Error>
    func signInWithNaver(_ signInWithNaverCompletion: (() -> Void)?) -> AnyPublisher<String, Error>
    func signOut() -> AnyPublisher<Void, Error>
}

// MARK: - AuthServices

final class AuthServices: NSObject, AuthServicesType {
    static let `default` = AuthServices()

    private lazy var appleAuthAPI = AppleAuthAPI()
    private lazy var googleAuthAPI = GoogleAuthAPI()
    private lazy var kakaoAuthAPI = KakaoAuthAPI()
    private lazy var naverAuthAPI = NaverAuthAPI()
    private lazy var cloudFunctionAuthAPI = CloudFunctionAuthAPI()
    private lazy var firebaseAuth = Auth.auth()
    private lazy var authStore = AuthStore.default

    lazy var isAuthenticated = CurrentValueSubject<Bool, Never>(authStore.getToken() != nil)

    override private init() {
        super.init()
    }

    func signUp(email: String, password: String) -> AnyPublisher<String, Error> {
        firebaseAuth.createUser(withEmail: email, password: password)
            .flatMap { result in
                if result.user.isEmailVerified {
                    return result.user.getIDTokenResult()
                        .eraseToAnyPublisher()
                } else {
                    return Fail<String, Error>(error: FirebaseAuthError.emailNotVerified)
                        .eraseToAnyPublisher()
                }
            }
            .handleEvents(receiveOutput: { [weak self] token in
                self?.authStore.saveToken(token)
                self?.isAuthenticated.send(true)
            })
            .eraseToAnyPublisher()
    }

    func sendEmailVerification() -> AnyPublisher<Void, Error> {
        if let user = firebaseAuth.currentUser {
            return user.sendEmailVerification()
                .eraseToAnyPublisher()
        } else {
            return Fail<Void, Error>(error: FirebaseAuthError.userNotFound)
                .eraseToAnyPublisher()
        }
    }

    func verifyEmail() -> AnyPublisher<String, Error> {
        guard let user = firebaseAuth.currentUser else {
            return Fail<String, Error>(error: FirebaseAuthError.userNotFound)
                .eraseToAnyPublisher()
        }
        return user.reloadCombine()
            .flatMap { user in
                if user.isEmailVerified {
                    return user.getIDTokenResult()
                        .eraseToAnyPublisher()
                } else {
                    return Fail<String, Error>(error: FirebaseAuthError.emailNotVerified)
                        .eraseToAnyPublisher()
                }
            }
            .handleEvents(receiveOutput: { [weak self] token in
                self?.authStore.saveToken(token)
                self?.isAuthenticated.send(true)
            })
            .eraseToAnyPublisher()
    }

    func sendPasswordReset(email: String) -> AnyPublisher<Void, Error> {
        firebaseAuth.sendPasswordReset(withEmail: email)
            .eraseToAnyPublisher()
    }

    func signIn(email: String, password: String) -> AnyPublisher<String, Error> {
        firebaseAuth.signIn(withEmail: email, password: password)
            .flatMap { result in
                if result.user.isEmailVerified {
                    return result.user.getIDTokenResult()
                        .eraseToAnyPublisher()
                } else {
                    return Fail<String, Error>(error: FirebaseAuthError.emailNotVerified)
                        .eraseToAnyPublisher()
                }
            }
            .handleEvents(receiveOutput: { [weak self] token in
                self?.authStore.saveToken(token)
                self?.isAuthenticated.send(true)
            })
            .eraseToAnyPublisher()
    }

    func signInWithApple() -> AnyPublisher<String, Error> {
        appleAuthAPI.signIn()
            .flatMap { [weak self] idToken, nonce in
                guard let self else { return Empty<AuthDataResult, Error>().eraseToAnyPublisher() }
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: nonce)
                return self.firebaseAuth
                    .signIn(with: credential)
                    .eraseToAnyPublisher()
            }
            .flatMap { result in
                if result.user.isEmailVerified {
                    return result.user.getIDTokenResult()
                        .eraseToAnyPublisher()
                } else {
                    return Fail<String, Error>(error: FirebaseAuthError.emailNotVerified)
                        .eraseToAnyPublisher()
                }
            }
            .handleEvents(receiveOutput: { [weak self] token in
                self?.authStore.saveToken(token)
                self?.isAuthenticated.send(true)
            })
            .eraseToAnyPublisher()
    }

    func signInWithGoogle() -> AnyPublisher<String, Error> {
        googleAuthAPI.signIn()
            .flatMap { [weak self] idToken, accessToken in
                guard let self else { return Empty<AuthDataResult, Error>().eraseToAnyPublisher() }
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                return self.firebaseAuth
                    .signIn(with: credential)
                    .eraseToAnyPublisher()
            }
            .flatMap { result in
                result.user.getIDTokenResult()
            }
            .handleEvents(receiveOutput: { [weak self] token in
                self?.authStore.saveToken(token)
                self?.isAuthenticated.send(true)
            })
            .eraseToAnyPublisher()
    }

    func signInWithKakao() -> AnyPublisher<String, Error> {
        kakaoAuthAPI.signIn()
            .flatMap { [weak self] in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.cloudFunctionAuthAPI.authWithKakao(token: $0)
            }
            .flatMap { [weak self] in
                guard let self else { return Empty<AuthDataResult, Error>().eraseToAnyPublisher() }
                return self.firebaseAuth
                    .signIn(withCustomToken: $0)
                    .eraseToAnyPublisher()
            }
            .flatMap { result in
                result.user.getIDTokenResult()
            }
            .handleEvents(receiveOutput: { [weak self] token in
                self?.authStore.saveToken(token)
                self?.isAuthenticated.send(true)
            })
            .eraseToAnyPublisher()
    }

    func signInWithNaver(_ signInWithNaverCompletion: (() -> Void)?) -> AnyPublisher<String, Error> {
        naverAuthAPI
            .signIn()
            .handleEvents(receiveOutput: { _ in signInWithNaverCompletion?() })
            .flatMap { [weak self] in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.cloudFunctionAuthAPI.authWithNaver(token: $0)
            }
            .flatMap { [weak self] in
                guard let self else { return Empty<AuthDataResult, Error>().eraseToAnyPublisher() }
                return self.firebaseAuth
                    .signIn(withCustomToken: $0)
                    .eraseToAnyPublisher()
            }
            .flatMap { result in
                result.user.getIDTokenResult()
            }
            .handleEvents(receiveOutput: { [weak self] token in
                self?.authStore.saveToken(token)
                self?.isAuthenticated.send(true)
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
        .flatMap { [weak self] _ in
            guard let self else { return Empty<Void, Error>().eraseToAnyPublisher() }
            return self.firebaseAuth
                .signOutCombine()
                .eraseToAnyPublisher()
        }
        .handleEvents(receiveOutput: { [weak self] in
            self?.authStore.clearToken()
            self?.isAuthenticated.send(false)
        })
        .eraseToAnyPublisher()
    }
}
