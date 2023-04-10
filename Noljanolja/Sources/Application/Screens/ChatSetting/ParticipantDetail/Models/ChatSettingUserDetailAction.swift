//
//  ChatSettingUserDetailAction.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//

import Foundation

enum ChatSettingUserDetailAction: CaseIterable, Equatable {
    case assignAdmin
    case removeParticipant

    var title: String {
        switch self {
        case .assignAdmin: return "Make admin"
        case .removeParticipant: return "Remove user"
        }
    }

    var color: ColorAsset {
        switch self {
        case .assignAdmin: return ColorAssets.neutralDarkGrey
        case .removeParticipant: return ColorAssets.red
        }
    }
}
