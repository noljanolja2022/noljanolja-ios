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
        case .chat: return "Chat"
        case .watch: return "Let’s get points by watching"
        case .wallet: return "Wallet"
        case .shop: return "Shop"
        case .news: return "News"
        }
    }

    var tabBarTitle: String {
        switch self {
        case .chat: return "Chat"
        case .watch: return "Watch"
        case .wallet: return "Wallet"
        case .shop: return "Shop"
        case .news: return "News"
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
