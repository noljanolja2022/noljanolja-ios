//
//  ChatSettingItemModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import Foundation

enum ChatSettingItemModel: Equatable {
    case updateTitle

    var image: String {
        switch self {
        case .updateTitle: return ImageAssets.icEdit.name
        }
    }

    var title: String {
        switch self {
        case .updateTitle: return "Change Chat room’s name"
        }
    }
}
