//
//  AuthUseCasesImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import Combine
import FirebaseAuth
import FirebaseAuthCombineSwift
import Foundation
import GoogleSignIn

// MARK: - AuthUseCases

protocol AuthUseCases {
    var isAuthenticated: CurrentValueSubject<Bool, Never> { get set }

    func signUp(email: String, password: String) -> AnyPublisher<String, Error>
    func sendEmailVerification() -> AnyPublisher<Void, Error>
    func verifyEmail() -> AnyPublisher<String, Error>
    func sendPasswordReset(email: String) -> AnyPublisher<Void, Error>

    func sendPhoneVerificationCode(_ phoneNumber: String, languageCode: String) -> AnyPublisher<String, Error>
    func verificationCode(verificationID: String, verificationCode: String) -> AnyPublisher<String, Error>

    func signIn(email: String, password: String) -> AnyPublisher<String, Error>
    func signInWithApple() -> AnyPublisher<String, Error>
    func signInWithGoogle(additionalScopes: [String]?) -> AnyPublisher<String, Error>
    func signInWithKakao() -> AnyPublisher<String, Error>
    func signInWithNaver(_ signInWithNaverCompletion: (() -> Void)?) -> AnyPublisher<String, Error>

    func getIDTokenResult() -> AnyPublisher<String, Error>

    func signOut() -> AnyPublisher<Void, Error>
}

extension AuthUseCases {
    func signInWithGoogle(additionalScopes: [String]? = nil) -> AnyPublisher<String, Error> {
        signInWithGoogle(additionalScopes: additionalScopes)
    }
}

// MARK: - AuthUseCasesImpl

final class AuthUseCasesImpl: NSObject, AuthUseCases {
    static let `default` = AuthUseCasesImpl()

    private lazy var notificationUseCases = NotificationUseCasesImpl.default
    private lazy var appleAuthRepository = AppleAuthRepository()
    private lazy var kakaoAuthRepository = KakaoAuthRepository()
    private lazy var naverAuthRepository = NaverAuthRepository()
    private lazy var cloudFunctionAuthRepository = CloudFunctionAuthRepository()
    private lazy var firebaseAuth = Auth.auth()
    private lazy var localAuthRepository = AuthLocalRepositoryImpl.default
    private lazy var contactLocalRepository: ContactLocalRepository = ContactLocalRepositoryImpl.default
    private lazy var conversationLocalRepository: ConversationLocalRepository = ConversationLocalRepositoryImpl.default
    private lazy var localDetailConversationRepository: LocalDetailConversationRepository = LocalDetailConversationRepositoryImpl.default
    private lazy var localMessageRepository: LocalMessageRepository = LocalMessageRepositoryImpl.default

    lazy var isAuthenticated = CurrentValueSubject<Bool, Never>(localAuthRepository.getToken() != nil)

    override private init() {
        super.init()
    }

    func signUp(email: String, password: String) -> AnyPublisher<String, Error> {
        firebaseAuth.createUser(withEmail: email, password: password)
            .flatMap { [weak self] _ in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.getIDTokenResult()
            }
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
            .flatMap { [weak self] _ in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.getIDTokenResult()
            }
            .eraseToAnyPublisher()
    }

    func sendPhoneVerificationCode(_ phoneNumber: String, languageCode: String) -> AnyPublisher<String, Error> {
        firebaseAuth.languageCode = languageCode
        return PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber)
            .eraseToAnyPublisher()
    }

    func verificationCode(verificationID: String, verificationCode: String) -> AnyPublisher<String, Error> {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        return firebaseAuth.signIn(with: credential)
            .flatMap { [weak self] _ in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.getIDTokenResult()
            }
            .eraseToAnyPublisher()
    }

    func sendPasswordReset(email: String) -> AnyPublisher<Void, Error> {
        firebaseAuth.sendPasswordReset(withEmail: email)
            .eraseToAnyPublisher()
    }

    func signIn(email: String, password: String) -> AnyPublisher<String, Error> {
        firebaseAuth.signIn(withEmail: email, password: password)
            .flatMap { [weak self] _ in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.getIDTokenResult()
            }
            .eraseToAnyPublisher()
    }

    func signInWithApple() -> AnyPublisher<String, Error> {
        appleAuthRepository.signIn()
            .flatMap { [weak self] idToken, nonce in
                guard let self else { return Empty<AuthDataResult, Error>().eraseToAnyPublisher() }
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: nonce)
                return self.firebaseAuth
                    .signIn(with: credential)
                    .eraseToAnyPublisher()
            }
            .flatMap { [weak self] _ in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.getIDTokenResult()
            }
            .eraseToAnyPublisher()
    }

    func signInWithGoogle(additionalScopes: [String]? = nil) -> AnyPublisher<String, Error> {
        GIDSignIn.sharedInstance.signInCombine(additionalScopes: additionalScopes)
            .flatMap { [weak self] result in
                guard let self else {
                    return Empty<AuthDataResult, Error>().eraseToAnyPublisher()
                }
                guard let idToken = result.user.idToken?.tokenString else {
                    return Fail(error: CommonError.informationNotFound(message: "IDToken not found"))
                        .eraseToAnyPublisher()
                }
                let accessToken = result.user.accessToken.tokenString
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                return self.firebaseAuth
                    .signIn(with: credential)
                    .eraseToAnyPublisher()
            }
            .flatMap { [weak self] _ in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.getIDTokenResult()
            }
            .eraseToAnyPublisher()
    }

    func signInWithKakao() -> AnyPublisher<String, Error> {
        kakaoAuthRepository.signIn()
            .flatMap { [weak self] in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.cloudFunctionAuthRepository.authWithKakao(token: $0)
            }
            .flatMap { [weak self] in
                guard let self else { return Empty<AuthDataResult, Error>().eraseToAnyPublisher() }
                return self.firebaseAuth
                    .signIn(withCustomToken: $0)
                    .eraseToAnyPublisher()
            }
            .flatMap { [weak self] _ in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.getIDTokenResult()
            }
            .eraseToAnyPublisher()
    }

    func signInWithNaver(_ signInWithNaverCompletion: (() -> Void)?) -> AnyPublisher<String, Error> {
        naverAuthRepository
            .signIn()
            .handleEvents(receiveOutput: { _ in signInWithNaverCompletion?() })
            .flatMap { [weak self] in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.cloudFunctionAuthRepository.authWithNaver(token: $0)
            }
            .flatMap { [weak self] in
                guard let self else { return Empty<AuthDataResult, Error>().eraseToAnyPublisher() }
                return self.firebaseAuth
                    .signIn(withCustomToken: $0)
                    .eraseToAnyPublisher()
            }
            .flatMap { [weak self] _ in
                guard let self else { return Empty<String, Error>().eraseToAnyPublisher() }
                return self.getIDTokenResult()
            }
            .eraseToAnyPublisher()
    }

    func getIDTokenResult() -> AnyPublisher<String, Error> {
        guard let user = firebaseAuth.currentUser else {
            return Fail<String, Error>(error: FirebaseAuthError.userNotFound)
                .eraseToAnyPublisher()
        }

        guard user.providerData.first(where: { $0.providerID == "password" }) == nil
            || user.isEmailVerified else {
            return Fail<String, Error>(error: FirebaseAuthError.emailNotVerified)
                .eraseToAnyPublisher()
        }

        return user.getIDTokenResult()
            .handleEvents(receiveOutput: { [weak self] token in
                self?.localAuthRepository.saveToken(token)
                self?.isAuthenticated.send(true)
            })
            .eraseToAnyPublisher()
    }

    func signOut() -> AnyPublisher<Void, Error> {
        notificationUseCases
            .deletePushToken()
            .flatMap { [weak self] _ in
                guard let self else { return Empty<Void, Error>().eraseToAnyPublisher() }
                return Publishers.CombineLatest4(
                    appleAuthRepository.signOutIfNeeded(),
                    GIDSignIn.sharedInstance.signOutIfNeededCombine(),
                    kakaoAuthRepository.signOutIfNeeded(),
                    naverAuthRepository.signOutIfNeeded()
                )
                .map { _ in () }
                .eraseToAnyPublisher()
            }
            .flatMap { [weak self] _ in
                guard let self else { return Empty<Void, Error>().eraseToAnyPublisher() }
                return self.firebaseAuth
                    .signOutCombine()
                    .eraseToAnyPublisher()
            }
            .handleEvents(receiveOutput: { [weak self] in
                guard let self else { return }
                self.localAuthRepository.clearToken()
                self.contactLocalRepository.deleteAll()
                self.conversationLocalRepository.deleteAll()
                self.localDetailConversationRepository.deleteAll()
                self.localMessageRepository.deleteAll()
                self.isAuthenticated.send(false)
            })
            .eraseToAnyPublisher()
    }
}
