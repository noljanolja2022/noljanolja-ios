//
//  ChatSettingNavigations.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import Foundation

// MARK: - ChatSettingNavigationType

enum ChatSettingNavigationType: Equatable {
    case contactList
    case settingItem(SettingItemType)

    enum SettingItemType {
        case adjustment
        case media

        init?(_ model: ChatSettingItemModelType) {
            switch model {
            case .changeNickname, .notification, .findMessage,
                 .theme, .deleteChatHistory, .blockUser, .secret:
                return nil
            case .adjustment:
                self = .adjustment
            case .media:
                self = .media
            }
        }
    }
}

// MARK: - ChatSettingFullScreenCoverType

enum ChatSettingFullScreenCoverType: Equatable {
    case participantDetail(ChatSettingParticipantModel)
}
