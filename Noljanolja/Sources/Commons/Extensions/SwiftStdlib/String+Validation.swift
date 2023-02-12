//
//  String+Validation.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/02/2023.
//

import Foundation

// MARK: - EmailError

enum EmailError: Error {
    case invalid

    var message: String {
        switch self {
        case .invalid: return L10n.Validation.Email.Error.invalid
        }
    }
}

// MARK: - PasswordError

enum PasswordError: Error {
    case invalidLength
    case letterRequired
    case digitRequired
    case specialCharactersRequired
    case notMatch

    var message: String {
        switch self {
        case .invalidLength: return L10n.Validation.Password.Error.invalidLength
        case .letterRequired: return L10n.Validation.Password.Error.letterRequired
        case .digitRequired: return L10n.Validation.Password.Error.digitRequired
        case .specialCharactersRequired: return L10n.Validation.Password.Error.specialCharactersRequired
        case .notMatch: return L10n.Validation.Password.Error.notMatch
        }
    }
}

// MARK: - StringValidator

enum StringValidator {
    static func validateEmail(_ email: String) -> EmailError? {
        email.isValidEmail ? nil : .invalid
    }

    static func validatePassword(_ password: String) -> PasswordError? {
        if password.count < 8 {
            return .invalidLength
        }
        return nil
    }

    static func validatePasswords(password: String, confirmPassword: String) -> PasswordError? {
        password == confirmPassword ? nil : .notMatch
    }
}
