//
//  TabBarItem.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/02/2023.
//

import SwiftUI

// MARK: - TabBarItem

enum TabBarItem: CaseIterable {
    case chat
    case event
    case content
    case shopping
    case profile
}

extension TabBarItem {
    var image: UIImage {
        switch self {
        case .chat: return ImageAssets.icMessage.image
        case .event: return ImageAssets.icCalendar.image
        case .content: return ImageAssets.icPlayCircle.image
        case .shopping: return ImageAssets.icCart.image
        case .profile: return ImageAssets.icPerson.image
        }
    }

    var name: String {
        switch self {
        case .chat: return "Chat"
        case .event: return "Event"
        case .content: return "Content"
        case .shopping: return "Shopping"
        case .profile: return "Profile"
        }
    }

    var isHighlight: Bool {
        switch self {
        case .chat, .event, .shopping, .profile: return false
        case .content: return true
        }
    }
}
