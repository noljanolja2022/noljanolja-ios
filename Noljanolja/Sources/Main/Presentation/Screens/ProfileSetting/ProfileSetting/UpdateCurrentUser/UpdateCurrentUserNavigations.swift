//
//  UpdateCurrentUserNavigations.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/04/2023.
//

import Foundation
import UIKit

// MARK: - UpdateCurrentUserActionSheetType

enum UpdateCurrentUserActionSheetType: String, Equatable {
    case avatar
    case gender
}

// MARK: Identifiable

extension UpdateCurrentUserActionSheetType: Identifiable {
    var id: String {
        rawValue
    }
}

// MARK: - UpdateCurrentUserFullScreenCoverType

enum UpdateCurrentUserFullScreenCoverType: Equatable {
    case imagePickerView(UIImagePickerController.SourceType)
    case selectCountry
    case datePicker
}
