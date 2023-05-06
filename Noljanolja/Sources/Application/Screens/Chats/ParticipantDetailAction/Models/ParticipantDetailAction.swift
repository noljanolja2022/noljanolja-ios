//
//  ParticipantDetailAction.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//

import Foundation

enum ParticipantDetailActionType: CaseIterable, Equatable {
    case chat
    case assignAdmin
    case removeParticipant

    var title: String {
        switch self {
        case .chat: return "Chat"
        case .assignAdmin: return "Make admin"
        case .removeParticipant: return "Remove user"
        }
    }

    var color: ColorAsset {
        switch self {
        case .chat, .assignAdmin: return ColorAssets.neutralDarkGrey
        case .removeParticipant: return ColorAssets.systemRed100
        }
    }
}
