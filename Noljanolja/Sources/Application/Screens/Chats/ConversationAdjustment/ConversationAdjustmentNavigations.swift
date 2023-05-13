//
//  File.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/05/2023.
//

import Foundation
import UIKit

// MARK: - ConversationAdjustmentActionSheetType

enum ConversationAdjustmentActionSheetType: String, Equatable {
    case avatar
}

// MARK: Identifiable

extension ConversationAdjustmentActionSheetType: Identifiable {
    var id: String {
        rawValue
    }
}

// MARK: - ConversationAdjustmentFullScreenCoverType

enum ConversationAdjustmentFullScreenCoverType: Equatable {
    case imagePickerView(UIImagePickerController.SourceType)
}
