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

    var message: String {
        switch self {
        case .invalidLength: return L10n.Validation.Password.Error.invalidLength
        case .letterRequired: return L10n.Validation.Password.Error.letterRequired
        case .digitRequired: return L10n.Validation.Password.Error.digitRequired
        case .specialCharactersRequired: return L10n.Validation.Password.Error.specialCharactersRequired
        }
    }
}

extension String {
    func validateEmail() -> EmailError? {
        isValidEmail ? nil : .invalid
    }

    func validatePassword() -> PasswordError? {
        if count < 1 {
            return .invalidLength
        }
        return nil
    }
}
