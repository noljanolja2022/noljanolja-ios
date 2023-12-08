// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum ColorAssets {
  internal static let neutralBlueGreyDeep = ColorAsset(name: "Neutral Blue Grey Deep")
  internal static let neutralBlueGrey = ColorAsset(name: "Neutral Blue Grey")
  internal static let neutralDarkGrey = ColorAsset(name: "Neutral Dark Grey")
  internal static let neutralDeepGrey = ColorAsset(name: "Neutral Deep Grey")
  internal static let neutralDeeperGrey = ColorAsset(name: "Neutral Deeper Grey")
  internal static let neutralGrey = ColorAsset(name: "Neutral Grey")
  internal static let neutralLightGrey = ColorAsset(name: "Neutral Light Grey")
  internal static let neutralLight = ColorAsset(name: "Neutral Light")
  internal static let neutralRawDarkGrey = ColorAsset(name: "Neutral Raw Dark Grey")
  internal static let neutralRawDeepGrey = ColorAsset(name: "Neutral Raw Deep Grey")
  internal static let neutralRawDeeperGrey = ColorAsset(name: "Neutral Raw Deeper Grey")
  internal static let neutralRawGrey = ColorAsset(name: "Neutral Raw Grey")
  internal static let neutralRawLightGrey = ColorAsset(name: "Neutral Raw Light Grey")
  internal static let neutralRawLight = ColorAsset(name: "Neutral Raw Light")
  internal static let primaryGreen100 = ColorAsset(name: "Primary Green 100")
  internal static let primaryGreen200 = ColorAsset(name: "Primary Green 200")
  internal static let primaryGreen300 = ColorAsset(name: "Primary Green 300")
  internal static let primaryGreen400 = ColorAsset(name: "Primary Green 400")
  internal static let primaryGreen50 = ColorAsset(name: "Primary Green 50")
  internal static let primaryGreen = ColorAsset(name: "Primary Green")
  internal static let secondaryYellow100 = ColorAsset(name: "Secondary Yellow 100")
  internal static let secondaryYellow200 = ColorAsset(name: "Secondary Yellow 200")
  internal static let secondaryYellow300 = ColorAsset(name: "Secondary Yellow 300")
  internal static let secondaryYellow400 = ColorAsset(name: "Secondary Yellow 400")
  internal static let secondaryYellow50 = ColorAsset(name: "Secondary Yellow 50")
  internal static let secondaryYellow500 = ColorAsset(name: "Secondary Yellow 500")
  internal static let lightBlue = ColorAsset(name: "Light Blue")
  internal static let systemBlue100 = ColorAsset(name: "System Blue 100")
  internal static let systemBlue50 = ColorAsset(name: "System Blue 50")
  internal static let systemBlue = ColorAsset(name: "System Blue")
  internal static let systemBrown = ColorAsset(name: "System Brown")
  internal static let systemGreen = ColorAsset(name: "System Green")
  internal static let systemRed100 = ColorAsset(name: "System Red 100")
  internal static let systemRed50 = ColorAsset(name: "System Red 50")

  // swiftlint:disable trailing_comma
  @available(*, deprecated, message: "All values properties are now deprecated")
  internal static let allColors: [ColorAsset] = [
    neutralBlueGreyDeep,
    neutralBlueGrey,
    neutralDarkGrey,
    neutralDeepGrey,
    neutralDeeperGrey,
    neutralGrey,
    neutralLightGrey,
    neutralLight,
    neutralRawDarkGrey,
    neutralRawDeepGrey,
    neutralRawDeeperGrey,
    neutralRawGrey,
    neutralRawLightGrey,
    neutralRawLight,
    primaryGreen100,
    primaryGreen200,
    primaryGreen300,
    primaryGreen400,
    primaryGreen50,
    primaryGreen,
    secondaryYellow100,
    secondaryYellow200,
    secondaryYellow300,
    secondaryYellow400,
    secondaryYellow50,
    secondaryYellow500,
    lightBlue,
    systemBlue100,
    systemBlue50,
    systemBlue,
    systemBrown,
    systemGreen,
    systemRed100,
    systemRed50,
  ]
  // swiftlint:enable trailing_comma
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

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
