//
//  KakaoAuthAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/02/2023.
//

import Combine
import Foundation
import KakaoSDKAuth
import KakaoSDKUser

// MARK: - KakaoAuthAPI

final class KakaoAuthAPI {
    func signIn() -> Future<String, Error> {
        Future { promise in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error {
                    promise(.failure(error))
                } else if let accessToken = oauthToken?.accessToken {
                    promise(.success(accessToken))
                } else {
                    promise(.failure(KakaoAuthorizationError.tokenNotExit))
                }
            }
        }
    }

    func signOutIfNeeded() -> Future<Void, Error> {
        Future { promise in
            guard AuthApi.hasToken() else {
                promise(.success(()))
                return
            }
            UserApi.shared.logout { error in
                promise(.success(()))
                if let error {
                    promise(.failure(error))
                    logger.error(error.localizedDescription)
                } else {
                    promise(.success(()))
                }
            }
        }
    }
}
