//
//  FirebaseUser+Combine.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/02/2023.
//

import Combine
import FirebaseAuth
import Foundation

extension FirebaseAuth.User {
    func getIDTokenResult() -> Future<String, Error> {
        Future { promise in
            self.getIDTokenResult(forcingRefresh: true) { authTokenResult, error in
                if let error {
                    promise(.failure(error))
                } else if let authTokenResult {
                    promise(.success(authTokenResult.token))
                }
            }
        }
    }

    func reloadCombine() -> Future<FirebaseAuth.User, Error> {
        Future { promise in
            self.reload { error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(self))
                }
            }
        }
    }
}
