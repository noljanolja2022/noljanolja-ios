//
//  MessageReactionAction.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/06/2023.
//

import Foundation

enum MessageReactionAction: CaseIterable {
    case reply
    case forward
    case copy
    case delete

    var title: String {
        switch self {
        case .reply: return "Reply"
        case .forward: return "Forward"
        case .copy: return "Copy"
        case .delete: return "Delete"
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
