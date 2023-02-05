//
//  KakaoAuthorizationAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/02/2023.
//

import Combine
import Foundation
import KakaoSDKUser

// MARK: - KakaoAuthorizationAPI

final class KakaoAuthorizationAPI {
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
}
