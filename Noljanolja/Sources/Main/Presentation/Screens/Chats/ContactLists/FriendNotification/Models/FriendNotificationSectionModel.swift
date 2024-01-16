//
//  FriendNotificationSectionModel.swift
//  Noljanolja
//
//  Created by Duy Dinh on 15/01/2024.
//

import Foundation

// MARK: - FriendNotificationHeaderType

enum FriendNotificationHeaderType: String {
    case new = "New"
    case previous = "Previous"
}

// MARK: - FriendNotificationSectionModel

struct FriendNotificationSectionModel: Equatable {
    let header: FriendNotificationHeaderType
    var items: [FriendNotificationItemModel]
}
