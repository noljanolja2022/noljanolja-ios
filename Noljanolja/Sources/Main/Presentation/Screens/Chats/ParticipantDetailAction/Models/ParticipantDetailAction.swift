//
//  ParticipantDetailAction.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//

import Foundation

enum ParticipantDetailActionType: Equatable {
    case chat(User)
    case assignAdmin
    case blockUser
    case removeParticipant

    var title: String {
        switch self {
        case .chat: return L10n.commonChat
        case .assignAdmin: return L10n.editChatMakeAdmin
        case .blockUser: return L10n.editChatBlockUser
        case .removeParticipant: return L10n.editChatRemoveUser
        }
    }

    var color: ColorAsset {
        switch self {
        case .chat, .assignAdmin, .blockUser: return ColorAssets.neutralDarkGrey
        case .removeParticipant: return ColorAssets.systemRed100
        }
    }
}
