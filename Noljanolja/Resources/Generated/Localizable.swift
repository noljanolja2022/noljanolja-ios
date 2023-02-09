// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Noljanolja
  internal static let appName = L10n.tr("Localizable", "app_name", fallback: "Noljanolja")
  internal enum Auth {
    internal enum JoinTheMembership {
      /// Join the membership
      internal static let title = L10n.tr("Localizable", "auth.join_the_membership.title", fallback: "Join the membership")
    }
    internal enum LogIn {
      /// Forgot your password?
      internal static let forgotPassword = L10n.tr("Localizable", "auth.log_in.forgot_password", fallback: "Forgot your password?")
      /// Log in with SNS
      internal static let logInWithSns = L10n.tr("Localizable", "auth.log_in.log_in_with_sns", fallback: "Log in with SNS")
      /// Log in
      internal static let title = L10n.tr("Localizable", "auth.log_in.title", fallback: "Log in")
      internal enum Email {
        /// Please enter your email
        internal static let placeholder = L10n.tr("Localizable", "auth.log_in.email.placeholder", fallback: "Please enter your email")
      }
      internal enum Password {
        /// Please enter a password
        internal static let placeholder = L10n.tr("Localizable", "auth.log_in.password.placeholder", fallback: "Please enter a password")
      }
    }
  }
  internal enum Error {
    /// Error
    internal static let title = L10n.tr("Localizable", "error.title", fallback: "Error")
  }
  internal enum Ok {
    /// OK
    internal static let title = L10n.tr("Localizable", "ok.title", fallback: "OK")
  }
  internal enum Validation {
    internal enum Email {
      internal enum Error {
        /// Please enter a valid email
        internal static let invalid = L10n.tr("Localizable", "validation.email.error.invalid", fallback: "Please enter a valid email")
      }
    }
    internal enum Password {
      internal enum Error {
        /// The password must have at least one digit
        internal static let digitRequired = L10n.tr("Localizable", "validation.password.error.digit_required", fallback: "The password must have at least one digit")
        /// The password must be 8-12 characters long
        internal static let invalidLength = L10n.tr("Localizable", "validation.password.error.invalid_length", fallback: "The password must be 8-12 characters long")
        /// The password must have at least one letter
        internal static let letterRequired = L10n.tr("Localizable", "validation.password.error.letter_required", fallback: "The password must have at least one letter")
        /// The password must have at least one special character (~!@#%^&*()-_=+)
        internal static let specialCharactersRequired = L10n.tr("Localizable", "validation.password.error.special_characters_required", fallback: "The password must have at least one special character (~!@#%^&*()-_=+)")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
