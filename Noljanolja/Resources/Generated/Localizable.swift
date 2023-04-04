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
  internal enum Common {
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
