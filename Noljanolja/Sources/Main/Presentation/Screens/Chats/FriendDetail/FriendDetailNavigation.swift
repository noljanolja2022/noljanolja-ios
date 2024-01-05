//
//  FriendDetailNavigation.swift
//  Noljanolja
//
//  Created by Duy Dinh on 16/11/2023.
//

import Foundation

// MARK: - FriendDetailNavigationType

enum FriendDetailNavigationType {
    case chat(Conversation)
    case sendPoint(User)
    case requestPoint(User)
}

// MARK: - FriendDetailFullScreenCoverType

enum FriendDetailFullScreenCoverType {}
