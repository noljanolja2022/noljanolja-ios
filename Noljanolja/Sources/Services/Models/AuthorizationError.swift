//
//  AuthorizationError.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/02/2023.
//

import Foundation

// MARK: - GoogleAuthorizationError

enum GoogleAuthorizationError: Error {
    case tokenNotExit
}

// MARK: - AppleAuthorizationError

enum AppleAuthorizationError: Error {
    case tokenNotExit
}

// MARK: - KakaoAuthorizationError

enum KakaoAuthorizationError: Error {
    case tokenNotExit
}

// MARK: - NaverAuthorizationError

enum NaverAuthorizationError: Error {
    case tokenNotExit
}

// MARK: - CloudFunctionAuthorizationError

enum CloudFunctionAuthorizationError: Error {
    case tokenNotExit
}
