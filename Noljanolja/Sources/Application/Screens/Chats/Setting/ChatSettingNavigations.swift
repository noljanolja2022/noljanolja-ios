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
    case settingItem(ChatSettingItemModelType)
}

// MARK: - ChatSettingFullScreenCoverType

enum ChatSettingFullScreenCoverType: Equatable {
    case participantDetail(ChatSettingParticipantModel)
}
