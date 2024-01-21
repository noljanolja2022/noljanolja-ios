//
//  MessageReactionsModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/06/2023.
//

import Foundation
import SwiftUI

struct MessageReactionsModel: Equatable {
    let quick: ReactIcon?
    let quickSaturation: Double
    let recents: [ReactIcon]
    let count: Int
    let backgroundColorName: String
    let horizontalAlignment: HorizontalAlignment
    let layoutDirection: LayoutDirection

    init(currentUser: User,
         reactionIcons: [ReactIcon],
         message: Message,
         positionTypeBySenderType: NormalMessageModel.PositionType) {
        let last = message.reactions.last(where: { $0.userId == currentUser.id }).flatMap { ReactIcon($0) }
        self.quick = {
            switch message.type {
            case .photo:
                return last ?? reactionIcons.first
            case .plaintext:
                if message.sender.id != currentUser.id, positionTypeBySenderType.contains(.last) {
                    return last ?? reactionIcons.first
                } else {
                    return last
                }
            case .sticker:
                return last
            case .eventJoined, .eventLeft, .eventUpdated, .unknown:
                return nil
            }
        }()
        self.quickSaturation = last == nil ? 0 : 1
        self.recents = Array(
            message.reactions
                .reversed()
                .reduce([ReactIcon]()) { result, item in
                    var result = result
                    let item = ReactIcon(item)
                    if !result.contains(item) {
                        result.append(item)
                    }
                    return result
                }
                .prefix(3)
        )
        self.count = message.reactions.count
        self.backgroundColorName = message.sender.id == currentUser.id
            ? AppThemeManager.shared.theme.primary50.description
            : ColorAssets.neutralRawLightGrey.name
        self.horizontalAlignment = message.sender.id == currentUser.id ? .trailing : .leading
        self.layoutDirection = message.sender.id == currentUser.id ? .rightToLeft : .leftToRight
    }
}
