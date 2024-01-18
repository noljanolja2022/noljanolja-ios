//
//  SettingNavigations.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/04/2023.
//

import Foundation
import UIKit

// MARK: - SettingNavigationType

enum SettingNavigationType: Equatable {
    case updateCurrentUser
    case sourceLicense
    case faq
    case changeAvatarAlbum
    case changeUsername
}

// MARK: - SettingFullScreenCoverType

enum SettingFullScreenCoverType: Equatable {
    case avatar
    case imagePickerView(UIImagePickerController.SourceType)
}
