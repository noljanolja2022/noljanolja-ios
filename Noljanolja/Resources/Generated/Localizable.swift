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
  /// My Info
  internal static let myInfo = L10n.tr("Localizable", "my_info", fallback: "My Info")
  /// My page
  internal static let myPage = L10n.tr("Localizable", "my_page", fallback: "My page")
  internal enum Auth {
    internal enum ConfirmPassword {
      /// Please confirm password
      internal static let placeholder = L10n.tr("Localizable", "auth.confirm_password.placeholder", fallback: "Please confirm password")
    }
    internal enum Email {
      /// Please enter your email
      internal static let placeholder = L10n.tr("Localizable", "auth.email.placeholder", fallback: "Please enter your email")
    }
    internal enum ForgotPassword {
      /// Forgot your password?
      internal static let title = L10n.tr("Localizable", "auth.forgot_password.title", fallback: "Forgot your password?")
    }
    internal enum JoinTheMembership {
      /// Join the membership
      internal static let title = L10n.tr("Localizable", "auth.join_the_membership.title", fallback: "Join the membership")
    }
    internal enum Password {
      /// Please enter password
      internal static let placeholder = L10n.tr("Localizable", "auth.password.placeholder", fallback: "Please enter password")
    }
    internal enum ResetPassword {
      /// Reset password
      internal static let title = L10n.tr("Localizable", "auth.reset_password.title", fallback: "Reset password")
      internal enum Retry {
        /// Resend reset password link
        internal static let title = L10n.tr("Localizable", "auth.reset_password.retry.title", fallback: "Resend reset password link")
      }
      internal enum Success {
        /// Reset password link has been sent to your email. Follow this link to reset your password
        internal static let description = L10n.tr("Localizable", "auth.reset_password.success.description", fallback: "Reset password link has been sent to your email. Follow this link to reset your password")
        /// Reset password link to your email has been sent
        internal static let title = L10n.tr("Localizable", "auth.reset_password.success.title", fallback: "Reset password link to your email has been sent")
      }
    }
    internal enum SignIn {
      /// Log in
      internal static let title = L10n.tr("Localizable", "auth.sign_in.title", fallback: "Log in")
    }
    internal enum SignInWithSns {
      /// Log in with SNS
      internal static let title = L10n.tr("Localizable", "auth.sign_in_with_sns.title", fallback: "Log in with SNS")
    }
    internal enum SignUp {
      /// Create account
      internal static let title = L10n.tr("Localizable", "auth.sign_up.title", fallback: "Create account")
      internal enum Step1 {
        /// You need to agree to the terms and conditions before signing up
        internal static let description = L10n.tr("Localizable", "auth.sign_up.step1.description", fallback: "You need to agree to the terms and conditions before signing up")
        /// STEP.1
        internal static let title = L10n.tr("Localizable", "auth.sign_up.step1.title", fallback: "STEP.1")
      }
      internal enum Step2 {
        /// Sign up with email and password
        internal static let description = L10n.tr("Localizable", "auth.sign_up.step2.description", fallback: "Sign up with email and password")
        /// STEP.2
        internal static let title = L10n.tr("Localizable", "auth.sign_up.step2.title", fallback: "STEP.2")
      }
      internal enum Step3 {
        /// Verification link has been sent to your email. Please check your email and follow it to continue
        internal static let description = L10n.tr("Localizable", "auth.sign_up.step3.description", fallback: "Verification link has been sent to your email. Please check your email and follow it to continue")
        /// STEP.3
        internal static let title = L10n.tr("Localizable", "auth.sign_up.step3.title", fallback: "STEP.3")
      }
    }
  }
  internal enum Common {
    /// Close
    internal static let close = L10n.tr("Localizable", "common.close", fallback: "Close")
    /// Next
    internal static let next = L10n.tr("Localizable", "common.next", fallback: "Next")
    /// OK
    internal static let ok = L10n.tr("Localizable", "common.ok", fallback: "OK")
    /// Previous
    internal static let previous = L10n.tr("Localizable", "common.previous", fallback: "Previous")
    internal enum Error {
      /// Error! An error occurred. Please try again later.
      internal static let message = L10n.tr("Localizable", "common.error.message", fallback: "Error! An error occurred. Please try again later.")
      /// Error
      internal static let title = L10n.tr("Localizable", "common.error.title", fallback: "Error")
    }
    internal enum Success {
      /// Success
      internal static let title = L10n.tr("Localizable", "common.success.title", fallback: "Success")
    }
  }
  internal enum MyInfo {
    /// Change Password
    internal static let changePassword = L10n.tr("Localizable", "my_info.change_password", fallback: "Change Password")
    /// Edit member information
    internal static let editMemberInformation = L10n.tr("Localizable", "my_info.edit_member_information", fallback: "Edit member information")
    /// Exchange account management
    internal static let exchangeAccountManagement = L10n.tr("Localizable", "my_info.exchange_account_management", fallback: "Exchange account management")
    /// Log out
    internal static let logOut = L10n.tr("Localizable", "my_info.log_out", fallback: "Log out")
    /// Setting
    internal static let setting = L10n.tr("Localizable", "my_info.setting", fallback: "Setting")
  }
  internal enum MyPage {
    /// Customer service center
    internal static let customerServiceCenter = L10n.tr("Localizable", "my_page.customer_service_center", fallback: "Customer service center")
    /// Hello %@!
    internal static func hello(_ p1: Any) -> String {
      return L10n.tr("Localizable", "my_page.hello", String(describing: p1), fallback: "Hello %@!")
    }
    /// Service guide
    internal static let serviceGuide = L10n.tr("Localizable", "my_page.service_guide", fallback: "Service guide")
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
        /// The password must be 8-12 characters
        internal static let invalidLength = L10n.tr("Localizable", "validation.password.error.invalid_length", fallback: "The password must be 8-12 characters")
        /// The password must have at least one letter
        internal static let letterRequired = L10n.tr("Localizable", "validation.password.error.letter_required", fallback: "The password must have at least one letter")
        /// Those passwords didn’t match. Try again
        internal static let notMatch = L10n.tr("Localizable", "validation.password.error.not_match", fallback: "Those passwords didn’t match. Try again")
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
