//
//  FriendNotificationItemModel.swift
//  Noljanolja
//
//  Created by Duy Dinh on 15/01/2024.
//

import Foundation

struct FriendNotificationItemModel: Equatable {
    let id: Int
    let title: String
    let avatarUrl: String?
    let dateTime: String
    let type: NotificationType
    let pointColor: String

    init(model: NotificationsModel) {
        id = model.id
        title = model.title
        dateTime = model.createdAt
        pointColor = model.type == .requestPoint ? ColorAssets.primaryYellow50.name : ColorAssets.systemBlue.name
        type = model.type ?? .requestPoint
        avatarUrl = nil
    }
}
