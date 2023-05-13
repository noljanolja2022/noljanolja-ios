//
//  ChatSettingHeaderModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/05/2023.
//

import Foundation

// MARK: - ChatSettingContentType

struct ChatSettingContentModel {
    let headerType: ChatSettingHeaderType
    let itemModel: ChatSettingItemModel
    let isLeaveEnabled: Bool
}
