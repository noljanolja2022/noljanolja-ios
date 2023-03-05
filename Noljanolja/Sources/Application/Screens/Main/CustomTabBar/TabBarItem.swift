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
    var imageName: String {
        switch self {
        case .chat: return ImageAssets.icChatFill.name
        case .event: return ImageAssets.icCelebrationFill.name
        case .content: return ImageAssets.icPlayCircleFill.name
        case .shopping: return ImageAssets.icStoreFill.name
        case .profile: return ImageAssets.icPersonFill.name
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
