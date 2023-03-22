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
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum ImageAssets {
  internal static let bgSplash = ImageAsset(name: "bg_splash")
  internal static let icAppMascot = ImageAsset(name: "ic_app_mascot")
  internal static let icApple = ImageAsset(name: "ic_apple")
  internal static let icArrowRight = ImageAsset(name: "ic_arrow_right")
  internal static let icAvatarPlaceholder = ImageAsset(name: "ic_avatar_placeholder")
  internal static let icBack = ImageAsset(name: "ic_back")
  internal static let icBicycle = ImageAsset(name: "ic_bicycle")
  internal static let icCelebrationFill = SymbolAsset(name: "ic_celebration_fill")
  internal static let icChatFill = SymbolAsset(name: "ic_chat_fill")
  internal static let icCheckCircle = ImageAsset(name: "ic_check_circle")
  internal static let icCheckCircleHightlight = ImageAsset(name: "ic_check_circle_hightlight")
  internal static let icChecked = ImageAsset(name: "ic_checked")
  internal static let icClose = ImageAsset(name: "ic_close")
  internal static let icCustomerServiceCenter = ImageAsset(name: "ic_customer_service_center")
  internal static let icGoogle = ImageAsset(name: "ic_google")
  internal static let icGroupAdd = ImageAsset(name: "ic_group_add")
  internal static let icHome = ImageAsset(name: "ic_home")
  internal static let icKakao = ImageAsset(name: "ic_kakao")
  internal static let icMenu = ImageAsset(name: "ic_menu")
  internal static let icNaver = ImageAsset(name: "ic_naver")
  internal static let icPersonFill = SymbolAsset(name: "ic_person_fill")
  internal static let icPlayCircleFill = SymbolAsset(name: "ic_play_circle_fill")
  internal static let icPpyy = ImageAsset(name: "ic_ppyy")
  internal static let icProfile = ImageAsset(name: "ic_profile")
  internal static let icQuestionmarkCircle = ImageAsset(name: "ic_questionmark_circle")
  internal static let icServiceGuide = ImageAsset(name: "ic_service_guide")
  internal static let icShop = ImageAsset(name: "ic_shop")
  internal static let icStoreFill = SymbolAsset(name: "ic_store_fill")
  internal static let icUnchecked = ImageAsset(name: "ic_unchecked")
  internal static let icWallet = ImageAsset(name: "ic_wallet")
  internal static let logo = ImageAsset(name: "logo")

  // swiftlint:disable trailing_comma
  @available(*, deprecated, message: "All values properties are now deprecated")
  internal static let allImages: [ImageAsset] = [
    bgSplash,
    icAppMascot,
    icApple,
    icArrowRight,
    icAvatarPlaceholder,
    icBack,
    icBicycle,
    icCheckCircle,
    icCheckCircleHightlight,
    icChecked,
    icClose,
    icCustomerServiceCenter,
    icGoogle,
    icGroupAdd,
    icHome,
    icKakao,
    icMenu,
    icNaver,
    icPpyy,
    icProfile,
    icQuestionmarkCircle,
    icServiceGuide,
    icShop,
    icUnchecked,
    icWallet,
    logo,
  ]
  @available(*, deprecated, message: "All values properties are now deprecated")
  internal static let allSymbols: [SymbolAsset] = [
    icCelebrationFill,
    icChatFill,
    icPersonFill,
    icPlayCircleFill,
    icStoreFill,
  ]
  // swiftlint:enable trailing_comma
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

internal struct SymbolAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(watchOS)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  internal typealias Configuration = UIImage.SymbolConfiguration
  internal typealias Image = UIImage

  @available(iOS 12.0, tvOS 12.0, watchOS 5.0, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load symbol asset named \(name).")
    }
    return result
  }

  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  internal func image(with configuration: Configuration) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, with: configuration) else {
      fatalError("Unable to load symbol asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: SymbolAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: SymbolAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: SymbolAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
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
