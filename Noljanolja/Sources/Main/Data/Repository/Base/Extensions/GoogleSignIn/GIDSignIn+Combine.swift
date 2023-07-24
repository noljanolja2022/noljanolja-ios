//
//  GoogleAuthAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/02/2023.
//

import Combine
import Foundation
import GoogleSignIn

// MARK: - GIDSignInScope

enum GIDSignInScope {
    static let youtube = "https://www.googleapis.com/auth/youtube.force-ssl"
}

// MARK: - GoogleAuthAPI

extension GIDSignIn {
    func signInIfNeededCombine(hint: String? = nil,
                               additionalScopes: [String]? = nil) -> AnyPublisher<GIDGoogleUser, Error> {
        if let currentUser {
            let grantedScopes = currentUser.grantedScopes ?? []
            let additionalScopes = additionalScopes ?? []
            if additionalScopes.isEmpty || grantedScopes.contains(additionalScopes) {
                return Just(currentUser)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                return currentUser.addScopes(scopes: additionalScopes)
                    .map { $0.user }
                    .eraseToAnyPublisher()
            }
        } else {
            return restorePreviousSignInCombine()
                .replaceError(with: nil)
                .flatMap { [weak self] currentUser in
                    guard let self else {
                        return Fail<GIDGoogleUser, Error>(error: CommonError.captureSelfNotFound)
                            .eraseToAnyPublisher()
                    }
                    if let currentUser {
                        let grantedScopes = currentUser.grantedScopes ?? []
                        let additionalScopes = additionalScopes ?? []
                        if additionalScopes.isEmpty || grantedScopes.contains(additionalScopes) {
                            return Just(currentUser)
                                .setFailureType(to: Error.self)
                                .eraseToAnyPublisher()
                        } else {
                            return currentUser.addScopes(scopes: additionalScopes)
                                .map { $0.user }
                                .eraseToAnyPublisher()
                        }
                    } else {
                        return self.signInCombine(hint: hint, additionalScopes: additionalScopes)
                            .map { $0.user }
                            .eraseToAnyPublisher()
                    }
                }
                .eraseToAnyPublisher()
        }
    }

    func signInCombine(hint: String? = nil,
                       additionalScopes: [String]? = nil) -> Future<GIDSignInResult, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(CommonError.captureSelfNotFound))
                return
            }
            guard let rootViewController = UIApplication.shared.rootKeyWindow?.rootViewController else {
                promise(.failure(CommonError.informationNotFound(message: "Presenting view controller not found")))
                return
            }
            self.signIn(withPresenting: rootViewController, hint: hint, additionalScopes: additionalScopes) { result, error in
                if let error {
                    promise(.failure(error))
                } else if let result {
                    promise(.success(result))
                } else {
                    promise(.failure(CommonError.informationNotFound(message: "Result not found")))
                }
            }
        }
    }

    func restorePreviousSignInCombine() -> Future<GIDGoogleUser?, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(CommonError.captureSelfNotFound))
                return
            }
            self.restorePreviousSignIn { user, error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(user))
                }
            }
        }
    }

    func signOutIfNeededCombine() -> Future<Void, Error> {
        Future { promise in
            if GIDSignIn.sharedInstance.currentUser != nil {
                GIDSignIn.sharedInstance.signOut()
            }
            promise(.success(()))
        }
    }
}
