//
//  GIDGoogleUser+Combine.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 24/07/2023.
//

import Combine
import Foundation
import GoogleSignIn

extension GIDGoogleUser {
    func addScopes(scopes: [String]) -> Future<GIDSignInResult, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(CommonError.captureSelfNotFound))
                return
            }
            guard let rootViewController = UIApplication.shared.rootKeyWindow?.rootViewController else {
                promise(.failure(CommonError.informationNotFound(message: "Presenting view controller not found")))
                return
            }
            self.addScopes(scopes, presenting: rootViewController) { result, error in
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
}
