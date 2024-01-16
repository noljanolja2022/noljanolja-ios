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

    init(model: NotificationsModel, avatar: String? = nil) {
        self.id = model.id
        self.title = model.title
        self.dateTime = model.createdAt
        self.pointColor = model.type == .requestPoint ? ColorAssets.primaryYellow50.name : ColorAssets.systemBlue.name
        self.type = model.type ?? .requestPoint
        self.avatarUrl = avatar
    }
}
