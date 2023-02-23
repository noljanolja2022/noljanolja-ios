//
//  TabBarItem.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/02/2023.
//

import SwiftUI

// MARK: - TabBarItem

enum TabBarItem: CaseIterable {
    case menu
    case home
    case wallet
    case shop
    case myPage
}

extension TabBarItem {
    var image: UIImage {
        switch self {
        case .menu: return ImageAssets.icMenu.image
        case .home: return ImageAssets.icHome.image
        case .wallet: return ImageAssets.icWallet.image
        case .shop: return ImageAssets.icShop.image
        case .myPage: return ImageAssets.icProfile.image
        }
    }

    var isHighlight: Bool {
        switch self {
        case .menu, .home, .shop, .myPage: return false
        case .wallet: return true
        }
    }
}
