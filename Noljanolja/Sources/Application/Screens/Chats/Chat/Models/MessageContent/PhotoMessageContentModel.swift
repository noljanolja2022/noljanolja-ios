//
//  Photo.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 24/03/2023.
//

import Foundation
import SwiftUI

// MARK: - PhotoMessageContentModel.ActionType

extension PhotoMessageContentModel {
    enum ActionType {
        case openImages
        case reaction(ReactIcon)
        case openMessageQuickReactionDetail(GeometryProxy?)
        case openMessageActionDetail(GeometryProxy?)
    }
}

// MARK: - PhotoMessageContentModel

struct PhotoMessageContentModel: Equatable {
    let isSendByCurrentUser: Bool
    let photos: [URL?]
    let createdAt: Date
    let status: MessageStatusModel.StatusType
    let isShareHidden: Bool
    let isForward: Bool
    let background: MessageContentBackgroundModel

    init(currentUser: User,
         message: Message,
         status: NormalMessageModel.StatusType,
         background: MessageContentBackgroundModel) {
        self.isSendByCurrentUser = currentUser.id == message.sender.id
        self.photos = message.attachments
            .map { $0.getPhotoURL(conversationID: message.conversationID) }
        self.createdAt = message.createdAt
        self.status = {
            guard message.sender.id == currentUser.id else {
                return .none
            }
            switch status {
            case .none, .sending, .sent: return .none
            case let .seen(users): return .seen(.single(!users.isEmpty))
            }
        }()
        self.isShareHidden = message.sender.id != currentUser.id
        self.isForward = message.shareMessage != nil
        self.background = background
    }
}
