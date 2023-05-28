//
//  ChatSettingItemModelType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import Foundation

// MARK: - ChatSettingItemModel

struct ChatSettingItemModel {
    let isTitleHidden: Bool
    let items: [ChatSettingItemModelType]
}

// MARK: - ChatSettingItemModelType

enum ChatSettingItemModelType: Equatable {
    case changeNickname
    case adjustment
    case notification(Bool)
    case media
    case findMessage
    case theme
    case deleteChatHistory
    case blockUser
    case secret

    var image: String {
        switch self {
        case .changeNickname, .adjustment: return ImageAssets.icEdit.name
        case .notification: return ImageAssets.icChatOffNotification.name
        case .media: return ImageAssets.icChatMedia.name
        case .findMessage: return ImageAssets.icSearch.name
        case .theme: return ImageAssets.icChatTheme.name
        case .deleteChatHistory: return ImageAssets.icChatDeleteHistory.name
        case .blockUser: return ImageAssets.icChatBlock.name
        case .secret: return ImageAssets.icChatSecret.name
        }
    }

    var title: String {
        switch self {
        case .changeNickname: return "Change nickname"
        case .adjustment: return "Chat room adjustment"
        case .notification: return "Turn off notification"
        case .media: return "Media, files, links"
        case .findMessage: return "Find message"
        case .theme: return "Theme Chat"
        case .deleteChatHistory: return "Delete chat history"
        case .blockUser: return L10n.editChatBlockUser
        case .secret: return "Secret Chat"
        }
    }
}
