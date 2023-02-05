//
//  CloudFunctionAuthorizationAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/02/2023.
//

import Combine
import FirebaseFunctions
import FirebaseFunctionsCombineSwift
import Foundation
import SwifterSwift

final class CloudFunctionAuthorizationAPI {
    private lazy var functions = Functions.functions(region: "asia-northeast3")

    func authWithKakao(token: String) -> AnyPublisher<String, Error> {
        auth(name: "kakaoAuth", token: token)
    }

    func authWithNaver(token: String) -> AnyPublisher<String, Error> {
        auth(name: "naverAuth", token: token)
    }

    private func auth(name: String, token: String) -> AnyPublisher<String, Error> {
        functions.httpsCallable("naverAuth").call(["token": token])
            .tryMap {
                if let result = $0.data as? [String: Any],
                   let token = result["firebaseToken"] as? String {
                    return token
                } else {
                    throw CloudFunctionAuthorizationError.tokenNotExit
                }
            }
            .eraseToAnyPublisher()
    }
}
