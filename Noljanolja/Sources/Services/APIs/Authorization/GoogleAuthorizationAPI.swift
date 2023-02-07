//
//  GoogleAuthorizationAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/02/2023.
//

import Combine
import Foundation
import GoogleSignIn

// MARK: - GoogleAuthorizationError

// MARK: - GoogleAuthorizationAPI

final class GoogleAuthorizationAPI {
    func signIn() -> Future<(String, String), Error> {
        Future { promise in
            guard let rootViewController = UIApplication.shared.rootKeyWindow?.rootViewController else { return }
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                if let error {
                    promise(.failure(error))
                } else if let idToken = result?.user.idToken?.tokenString, let accessToken = result?.user.accessToken.tokenString {
                    promise(.success((idToken, accessToken)))
                } else {
                    promise(.failure(GoogleAuthorizationError.tokenNotExit))
                }
            }
        }
    }

    func signOutIfNeeded() -> Future<Void, Error> {
        Future { promise in
            if GIDSignIn.sharedInstance.currentUser != nil {
                GIDSignIn.sharedInstance.signOut()
            }
            promise(.success(()))
        }
    }
}
