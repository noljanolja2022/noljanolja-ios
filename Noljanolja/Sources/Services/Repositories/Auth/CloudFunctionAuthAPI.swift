//
//  CloudFunctionAuthAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/02/2023.
//

import Combine
import FirebaseFunctions
import FirebaseFunctionsCombineSwift
import Foundation

final class CloudFunctionAuthAPI {
    private lazy var functions = Functions.functions(region: "asia-northeast3")

    func authWithKakao(token: String) -> AnyPublisher<String, Error> {
        auth(functionName: "api/auth/kakao", token: token)
    }

    func authWithNaver(token: String) -> AnyPublisher<String, Error> {
        auth(functionName: "api/auth/naver", token: token)
    }

    private func auth(functionName: String, token: String) -> AnyPublisher<String, Error> {
        functions.httpsCallable(functionName).call(["token": token])
            .tryMap {
                if let token = $0.data as? String {
                    return token
                } else {
                    throw CloudFunctionAuthError.tokenNotExit
                }
            }
            .eraseToAnyPublisher()
    }
}
