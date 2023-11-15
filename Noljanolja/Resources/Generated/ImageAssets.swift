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
  internal static let bnAddFriendQr = ImageAsset(name: "bn_add_friend_qr")
  internal static let icContactCalendar = ImageAsset(name: "ic_contact_calendar")
  internal static let icScan = ImageAsset(name: "ic_scan")
  internal static let icAddPerson = ImageAsset(name: "ic_add_person")
  internal static let icChatBlock = ImageAsset(name: "ic_chat_block")
  internal static let icChatBubble = ImageAsset(name: "ic_chat_bubble")
  internal static let icChatCamera = ImageAsset(name: "ic_chat_camera")
  internal static let icChatContact = ImageAsset(name: "ic_chat_contact")
  internal static let icChatDeleteHistory = ImageAsset(name: "ic_chat_delete_history")
  internal static let icChatEditTitle = ImageAsset(name: "ic_chat_edit_title")
  internal static let icChatEmoji = ImageAsset(name: "ic_chat_emoji")
  internal static let icChatEvent = ImageAsset(name: "ic_chat_event")
  internal static let icChatFile = ImageAsset(name: "ic_chat_file")
  internal static let icChatGif = ImageAsset(name: "ic_chat_gif")
  internal static let icChatImageAsset = ImageAsset(name: "ic_chat_image_asset")
  internal static let icChatLocation = ImageAsset(name: "ic_chat_location")
  internal static let icChatMedia = ImageAsset(name: "ic_chat_media")
  internal static let icChatNew = ImageAsset(name: "ic_chat_new")
  internal static let icChatNewGroup = ImageAsset(name: "ic_chat_new_group")
  internal static let icChatNewSingle = ImageAsset(name: "ic_chat_new_single")
  internal static let icChatOffNotification = ImageAsset(name: "ic_chat_off_notification")
  internal static let icChatPlaceholderGroup = ImageAsset(name: "ic_chat_placeholder_group")
  internal static let icChatPlaceholderSingle = ImageAsset(name: "ic_chat_placeholder_single")
  internal static let icChatSecret = ImageAsset(name: "ic_chat_secret")
  internal static let icChatSeen = ImageAsset(name: "ic_chat_seen")
  internal static let icChatStickerRecent = ImageAsset(name: "ic_chat_sticker_recent")
  internal static let icChatStickerStore = ImageAsset(name: "ic_chat_sticker_store")
  internal static let icChatTheme = ImageAsset(name: "ic_chat_theme")
  internal static let icChatVoice = ImageAsset(name: "ic_chat_voice")
  internal static let icChatWallet = ImageAsset(name: "ic_chat_wallet")
  internal static let icSend = ImageAsset(name: "ic_send")
  internal static let icCheckboxCircleChecked = ImageAsset(name: "ic_checkbox_circle_checked")
  internal static let icCheckboxCircleUnchecked = ImageAsset(name: "ic_checkbox_circle_unchecked")
  internal static let icCheckboxRoundedChecked = ImageAsset(name: "ic_checkbox_rounded_checked")
  internal static let icCheckboxRoundedUnchecked = ImageAsset(name: "ic_checkbox_rounded_unchecked")
  internal static let icAdd = ImageAsset(name: "ic_add")
  internal static let icAppMascot = ImageAsset(name: "ic_app_mascot")
  internal static let icApple = ImageAsset(name: "ic_apple")
  internal static let icArrowRight = ImageAsset(name: "ic_arrow_right")
  internal static let icAvatarPlaceholder = ImageAsset(name: "ic_avatar_placeholder")
  internal static let icBack = ImageAsset(name: "ic_back")
  internal static let icCameraFill = ImageAsset(name: "ic_camera_fill")
  internal static let icChange = ImageAsset(name: "ic_change")
  internal static let icChecked = ImageAsset(name: "ic_checked")
  internal static let icClose = ImageAsset(name: "ic_close")
  internal static let icCoin = ImageAsset(name: "ic_coin")
  internal static let icCopy = ImageAsset(name: "ic_copy")
  internal static let icDelete = ImageAsset(name: "ic_delete")
  internal static let icDownload = ImageAsset(name: "ic_download")
  internal static let icEdit = ImageAsset(name: "ic_edit")
  internal static let icExchange = ImageAsset(name: "ic_exchange")
  internal static let icForward = ImageAsset(name: "ic_forward")
  internal static let icGift = ImageAsset(name: "ic_gift")
  internal static let icGoogle = ImageAsset(name: "ic_google")
  internal static let icIgnore = ImageAsset(name: "ic_ignore")
  internal static let icLink = ImageAsset(name: "ic_link")
  internal static let icMenu = ImageAsset(name: "ic_menu")
  internal static let icMore = ImageAsset(name: "ic_more")
  internal static let icNotifications = ImageAsset(name: "ic_notifications")
  internal static let icPoint = ImageAsset(name: "ic_point")
  internal static let icQuestion = ImageAsset(name: "ic_question")
  internal static let icRank = ImageAsset(name: "ic_rank")
  internal static let icReply = ImageAsset(name: "ic_reply")
  internal static let icSearch = ImageAsset(name: "ic_search")
  internal static let icSettingFill = ImageAsset(name: "ic_setting_fill")
  internal static let icSettingOutline = ImageAsset(name: "ic_setting_outline")
  internal static let icShare = ImageAsset(name: "ic_share")
  internal static let icTimeRecent = ImageAsset(name: "ic_time_recent")
  internal static let icWallet2 = ImageAsset(name: "ic_wallet_2")
  internal static let logo = ImageAsset(name: "logo")
  internal static let bgFriendsHeader = ImageAsset(name: "bg_friends_header")
  internal static let icCenterFocus = ImageAsset(name: "ic_center_focus")
  internal static let icFacebook = ImageAsset(name: "ic_facebook")
  internal static let icMessenger = ImageAsset(name: "ic_messenger")
  internal static let icTelegram = ImageAsset(name: "ic_telegram")
  internal static let icTwitter = ImageAsset(name: "ic_twitter")
  internal static let icWhatapps = ImageAsset(name: "ic_whatapps")
  internal static let icChat = ImageAsset(name: "ic_chat")
  internal static let icFriends = ImageAsset(name: "ic_friends")
  internal static let icNews = ImageAsset(name: "ic_news")
  internal static let icShop = ImageAsset(name: "ic_shop")
  internal static let icVideo = ImageAsset(name: "ic_video")
  internal static let icWallet = ImageAsset(name: "ic_wallet")
  internal static let bgPointGreen = ImageAsset(name: "bg_point_green")
  internal static let bgPointYellow = ImageAsset(name: "bg_point_yellow")
  internal static let bgWalletHeader = ImageAsset(name: "bg_wallet_header")
  internal static let bnCash = ImageAsset(name: "bn_cash")
  internal static let bnPoint = ImageAsset(name: "bn_point")
  internal static let bnReferral = ImageAsset(name: "bn_referral")
  internal static let icReferral1 = ImageAsset(name: "ic_referral-1")
  internal static let icReferral2 = ImageAsset(name: "ic_referral-2")
  internal static let icReferral3 = ImageAsset(name: "ic_referral-3")
  internal static let icReferral4 = ImageAsset(name: "ic_referral-4")
  internal static let icPpyy = ImageAsset(name: "ic_ppyy")
  internal static let icSplashMultiCoin = ImageAsset(name: "ic_splash_multi_coin")
  internal static let icSplashSingleCoin = ImageAsset(name: "ic_splash_single_coin")

  // swiftlint:disable trailing_comma
  @available(*, deprecated, message: "All values properties are now deprecated")
  internal static let allImages: [ImageAsset] = [
    bnAddFriendQr,
    icContactCalendar,
    icScan,
    icAddPerson,
    icChatBlock,
    icChatBubble,
    icChatCamera,
    icChatContact,
    icChatDeleteHistory,
    icChatEditTitle,
    icChatEmoji,
    icChatEvent,
    icChatFile,
    icChatGif,
    icChatImageAsset,
    icChatLocation,
    icChatMedia,
    icChatNew,
    icChatNewGroup,
    icChatNewSingle,
    icChatOffNotification,
    icChatPlaceholderGroup,
    icChatPlaceholderSingle,
    icChatSecret,
    icChatSeen,
    icChatStickerRecent,
    icChatStickerStore,
    icChatTheme,
    icChatVoice,
    icChatWallet,
    icSend,
    icCheckboxCircleChecked,
    icCheckboxCircleUnchecked,
    icCheckboxRoundedChecked,
    icCheckboxRoundedUnchecked,
    icAdd,
    icAppMascot,
    icApple,
    icArrowRight,
    icAvatarPlaceholder,
    icBack,
    icCameraFill,
    icChange,
    icChecked,
    icClose,
    icCoin,
    icCopy,
    icDelete,
    icDownload,
    icEdit,
    icExchange,
    icForward,
    icGift,
    icGoogle,
    icIgnore,
    icLink,
    icMenu,
    icMore,
    icNotifications,
    icPoint,
    icQuestion,
    icRank,
    icReply,
    icSearch,
    icSettingFill,
    icSettingOutline,
    icShare,
    icTimeRecent,
    icWallet2,
    logo,
    bgFriendsHeader,
    icCenterFocus,
    icFacebook,
    icMessenger,
    icTelegram,
    icTwitter,
    icWhatapps,
    icChat,
    icFriends,
    icNews,
    icShop,
    icVideo,
    icWallet,
    bgPointGreen,
    bgPointYellow,
    bgWalletHeader,
    bnCash,
    bnPoint,
    bnReferral,
    icReferral1,
    icReferral2,
    icReferral3,
    icReferral4,
    icPpyy,
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
