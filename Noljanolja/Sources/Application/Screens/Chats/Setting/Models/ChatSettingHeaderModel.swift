//
//  ChatSettingParticipantModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import Foundation

// MARK: - ChatSettingHeaderType

enum ChatSettingHeaderType {
    case single(SingleChatSettingHeaderModel)
    case group(GroupChatSettingHeaderModel)
}

// MARK: - SingleChatSettingHeaderModel

struct SingleChatSettingHeaderModel {
    let participantModel: ChatSettingParticipantModel?
}

// MARK: - GroupChatSettingHeaderModel

struct GroupChatSettingHeaderModel {
    let isAddParticipantsEnabled: Bool
    let participantModels: [ChatSettingParticipantModel]
}

// MARK: - ChatSettingParticipantModel

struct ChatSettingParticipantModel: Equatable {
    let user: User
    let currentUser: User?
    let admin: User?

    init?(user: User?, currentUser: User?, admin: User?) {
        guard let user else {
            return nil
        }
        self.user = user
        self.currentUser = currentUser
        self.admin = admin
    }

    var avatar: String? {
        user.avatar
    }

    var displayName: String? {
        if user.id == currentUser?.id {
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

    var actionTypes: [ParticipantDetailActionType] {
        if currentUser?.id != user.id {
            if currentUser?.id == admin?.id {
                return [.chat(user), .assignAdmin, .removeParticipant]
            } else {
                return [.chat(user)]
            }
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
