//
//  MainNavigations.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/04/2023.
//

import Foundation

enum MainTabType: Equatable {
    case chat
    case watch
    case wallet
    case shop
    case news

    var isNavigationBarHidden: Bool {
        switch self {
        case .chat, .watch, .shop, .news: return false
        case .wallet: return true
        }
    }

    var navigationBarTitle: String {
        switch self {
        case .chat: return L10n.commonChat
        case .watch: return L10n.videoTitle
        case .wallet: return L10n.homeWallet
        case .shop: return L10n.homeShop
        case .news: return L10n.homeNews
        }
    }

    var tabBarTitle: String {
        switch self {
        case .chat: return L10n.commonChat
        case .watch: return L10n.homeWatch
        case .wallet: return L10n.homeWallet
        case .shop: return L10n.homeShop
        case .news: return L10n.homeNews
        }
    }

    var imageName: String {
        switch self {
        case .chat: return ImageAssets.icChat.name
        case .watch: return ImageAssets.icVideo.name
        case .wallet: return ImageAssets.icWallet.name
        case .shop: return ImageAssets.icShop.name
        case .news: return ImageAssets.icNews.name
        }
    }
}
