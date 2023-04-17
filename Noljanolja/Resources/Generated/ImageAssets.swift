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
  internal static let icAdd = ImageAsset(name: "ic_add")
  internal static let icAddChat = ImageAsset(name: "ic_add_chat")
  internal static let icAddCircle = ImageAsset(name: "ic_add_circle")
  internal static let icAppMascot = ImageAsset(name: "ic_app_mascot")
  internal static let icArrowRight = ImageAsset(name: "ic_arrow_right")
  internal static let icAvatarPlaceholder = ImageAsset(name: "ic_avatar_placeholder")
  internal static let icBack = ImageAsset(name: "ic_back")
  internal static let icCamera = ImageAsset(name: "ic_camera")
  internal static let icCheckCircle = ImageAsset(name: "ic_check_circle")
  internal static let icChecked = ImageAsset(name: "ic_checked")
  internal static let icCircleChecked = ImageAsset(name: "ic_circle_checked")
  internal static let icCircleUnchecked = ImageAsset(name: "ic_circle_unchecked")
  internal static let icClose = ImageAsset(name: "ic_close")
  internal static let icEdit = ImageAsset(name: "ic_edit")
  internal static let icEmoji = ImageAsset(name: "ic_emoji")
  internal static let icGroupChat = ImageAsset(name: "ic_group_chat")
  internal static let icKeyboardVoice = ImageAsset(name: "ic_keyboard_voice")
  internal static let icKing = ImageAsset(name: "ic_king")
  internal static let icMenu = ImageAsset(name: "ic_menu")
  internal static let icPhoto = ImageAsset(name: "ic_photo")
  internal static let icPoint = ImageAsset(name: "ic_point")
  internal static let icPointAccumulated = ImageAsset(name: "ic_point_accumulated")
  internal static let icPointReload = ImageAsset(name: "ic_point_reload")
  internal static let icPpyy = ImageAsset(name: "ic_ppyy")
  internal static let icSend = ImageAsset(name: "ic_send")
  internal static let icSetting = ImageAsset(name: "ic_setting")
  internal static let icSingleChat = ImageAsset(name: "ic_single_chat")
  internal static let icUnchecked = ImageAsset(name: "ic_unchecked")
  internal static let logo = ImageAsset(name: "logo")
  internal static let icSplashMultiCoin = ImageAsset(name: "ic_splash_multi_coin")
  internal static let icSplashSingleCoin = ImageAsset(name: "ic_splash_single_coin")

  // swiftlint:disable trailing_comma
  @available(*, deprecated, message: "All values properties are now deprecated")
  internal static let allImages: [ImageAsset] = [
    icAdd,
    icAddChat,
    icAddCircle,
    icAppMascot,
    icArrowRight,
    icAvatarPlaceholder,
    icBack,
    icCamera,
    icCheckCircle,
    icChecked,
    icCircleChecked,
    icCircleUnchecked,
    icClose,
    icEdit,
    icEmoji,
    icGroupChat,
    icKeyboardVoice,
    icKing,
    icMenu,
    icPhoto,
    icPoint,
    icPointAccumulated,
    icPointReload,
    icPpyy,
    icSend,
    icSetting,
    icSingleChat,
    icUnchecked,
    logo,
    icSplashMultiCoin,
    icSplashSingleCoin,
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
