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

    func signOutIfNeededCombine() -> Future<Void, Error> {
        Future { promise in
            if GIDSignIn.sharedInstance.currentUser != nil {
                GIDSignIn.sharedInstance.signOut()
            }
            promise(.success(()))
        }
    }
}
