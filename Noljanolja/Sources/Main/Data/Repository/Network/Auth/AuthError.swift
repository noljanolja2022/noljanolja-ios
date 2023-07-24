//
//  AuthError.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/02/2023.
//

import Foundation

// MARK: - AppleAuthError

enum AppleAuthError: Error {
    case tokenNotExit
}

// MARK: - KakaoAuthError

enum KakaoAuthError: Error {
    case tokenNotExit
}

// MARK: - NaverAuthError

enum NaverAuthError: Error {
    case tokenNotExit
}

// MARK: - CloudFunctionAuthError

enum CloudFunctionAuthError: Error {
    case tokenNotExit
}

// MARK: - FirebaseAuthError

enum FirebaseAuthError: Error {
    case userNotFound
    case emailNotVerified
}
