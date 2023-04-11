//
//  ChatSettingParticipantModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import Foundation

struct ChatSettingParticipantModel: Equatable {
    let user: User
    let currentUser: User?
    let admin: User?

    var avatar: String? {
        user.avatar
    }

    var displayName: String? {
        if user == currentUser {
            return "You"
        } else {
            return user.name
        }
    }

    var originalName: String? {
        if user == currentUser {
            return user.name
        } else {
            return nil
        }
    }

    var isAdmin: Bool {
        user == admin
    }

    var chatSettingUserDetailActions: [ChatSettingUserDetailAction] {
        if currentUser?.id != user.id, currentUser?.id == admin?.id {
            return [.assignAdmin, .removeParticipant]
        } else {
            return []
        }
    }

    init(user: User, currentUser: User? = nil, admin: User? = nil) {
        self.user = user
        self.currentUser = currentUser
        self.admin = admin
    }
}
