//
//  MainNavigations.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/04/2023.
//

import Foundation
import SwiftUIX

// MARK: - HomeTabType

enum HomeTabType: Equatable {
    case chat
    case friends
    case watch
    case wallet
    case shop

    var isNavigationBarHidden: Bool {
        switch self {
        case .chat: return false
        case .wallet, .shop, .watch, .friends: return true
        }
    }

    var navigationBarTitle: String {
        switch self {
        case .chat: return L10n.commonChat
        case .friends: return L10n.commonFriends
        case .watch: return L10n.videoTitle
        case .wallet: return L10n.homeWallet
        case .shop: return L10n.homeShop
        }
    }

    var tabBarTitle: String {
        switch self {
        case .chat: return L10n.commonChat
        case .friends: return L10n.commonFriends
        case .watch: return L10n.homeWatch
        case .wallet: return L10n.homeWallet
        case .shop: return L10n.homeShop
        }
    }

    var imageName: String {
        switch self {
        case .chat: return ImageAssets.icChat.name
        case .friends: return ImageAssets.icFriends.name
        case .watch: return ImageAssets.icVideo.name
        case .wallet: return ImageAssets.icWallet.name
        case .shop: return ImageAssets.icShop.name
        }
    }
}

// MARK: - HomeAlertActionType

enum HomeAlertActionType {
    case exitApp
}

// MARK: - HomeNavigationType

enum HomeNavigationType {
    case addFriends
    case searchVideo
}

// MARK: - HomeScreenCoverType

enum HomeScreenCoverType: Equatable {
    case notificationSetting
    case banners([Banner])
}
