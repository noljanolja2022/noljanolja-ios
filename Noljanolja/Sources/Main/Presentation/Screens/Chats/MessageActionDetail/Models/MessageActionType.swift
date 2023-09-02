//
//  MessageActionType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/06/2023.
//

import Foundation

enum MessageActionType: CaseIterable {
    case reply
    case forward
    case copy
    case delete

    var title: String {
        switch self {
        case .reply: return L10n.chatActionReply
        case .forward: return L10n.chatActionForward
        case .copy: return L10n.chatActionCopy
        case .delete: return L10n.chatActionDelete
        }
    }

    var imageName: String {
        switch self {
        case .reply: return ImageAssets.icReply.name
        case .forward: return ImageAssets.icForward.name
        case .copy: return ImageAssets.icCopy.name
        case .delete: return ImageAssets.icDelete.name
        }
    }
}
