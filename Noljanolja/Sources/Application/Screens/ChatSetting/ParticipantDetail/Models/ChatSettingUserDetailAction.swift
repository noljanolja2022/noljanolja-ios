//
//  ChatSettingUserDetailAction.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//

import Foundation

enum ChatSettingUserDetailAction: CaseIterable, Equatable {
    case makeAdmin
    case removeUser

    var title: String {
        switch self {
        case .makeAdmin: return "Make admin"
        case .removeUser: return "Remove user"
        }
    }

    var color: ColorAsset {
        switch self {
        case .makeAdmin: return ColorAssets.neutralDarkGrey
        case .removeUser: return ColorAssets.red
        }
    }
}
