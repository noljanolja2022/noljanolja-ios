//
//  VideoMessageContentModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/07/2023.
//

import Foundation
import SwiftUI

// MARK: - VideoMessageContentModel.ActionType

extension VideoMessageContentModel {
    enum ActionType {
        case openVideoDetail(Video?)
        case openMessageQuickReactionDetail(GeometryProxy?)
        case openMessageActionDetail(GeometryProxy?)
    }
}

// MARK: - VideoMessageContentModel

struct VideoMessageContentModel: Equatable {
    let video: Video?
    let thumbnail: String?
    let title: String?
    let background: MessageContentBackgroundModel

    init(message: Message,
         background: MessageContentBackgroundModel) {
        self.video = message.shareVideo
        self.thumbnail = message.shareVideo?.thumbnail
        self.title = message.shareVideo?.title
        self.background = background
    }
}
