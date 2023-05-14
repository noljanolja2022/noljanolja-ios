//
//  ChatSettingItemModelBuilder.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/05/2023.
//

import Foundation

struct ChatSettingItemModelBuilder {
    let conversation: Conversation
    let currentUser: User

    init(conversation: Conversation, currentUser: User) {
        self.conversation = conversation
        self.currentUser = currentUser
    }

    func build() -> ChatSettingContentModel? {
        switch conversation.type {
        case .single:
            let headerType: ChatSettingHeaderType = {
                let participantModel = ChatSettingParticipantModel(
                    user: conversation.participants.filter { $0.id != currentUser.id }.first,
                    currentUser: currentUser,
                    admin: conversation.admin
                )
                return .single(
                    SingleChatSettingHeaderModel(
                        participantModel: participantModel
                    )
                )
            }()
            let itemModel: ChatSettingItemModel = {
                ChatSettingItemModel(
                    isTitleHidden: true,
                    items: [
                        .changeNickname,
                        .notification(true),
                        .media,
                        .findMessage,
                        .deleteChatHistory,
                        .blockUser,
                        .secret,
                        .theme
                    ]
                )
            }()
            let contentType = ChatSettingContentModel(
                headerType: headerType,
                itemModel: itemModel,
                isLeaveEnabled: false
            )
            return contentType
        case .group:
            let headerType: ChatSettingHeaderType = {
                let isAddParticipantsEnabled = conversation.admin.id == currentUser.id
                let participantModels = {
                    let adminAndCurrentParticipants = conversation.participants
                        .filter {
                            $0.id == conversation.admin.id && $0.id == currentUser.id
                        }
                    let adminParticipants = conversation.participants
                        .filter {
                            $0.id == conversation.admin.id && $0.id != currentUser.id
                        }
                    let currentParticipants = conversation.participants
                        .filter {
                            $0.id != conversation.admin.id && $0.id == currentUser.id
                        }
                    let otherParticipants = conversation.participants
                        .filter {
                            $0.id != conversation.admin.id && $0.id != currentUser.id
                        }
                        .sorted(currentUser: currentUser)

                    let participantModels = (adminAndCurrentParticipants + adminParticipants + currentParticipants + otherParticipants)
                        .compactMap { user in
                            ChatSettingParticipantModel(user: user, currentUser: currentUser, admin: conversation.admin)
                        }

                    return participantModels
                }()
                return .group(
                    GroupChatSettingHeaderModel(
                        isAddParticipantsEnabled: isAddParticipantsEnabled,
                        participantModels: participantModels
                    )
                )
            }()

            let itemModel = ChatSettingItemModel(
                isTitleHidden: false,
                items: {
                    if conversation.admin.id == currentUser.id {
                        return [
                            .adjustment,
                            .notification(true),
                            .media,
                            .findMessage,
                            .theme,
                            .deleteChatHistory
                        ]
                    } else {
                        return [
                            .notification(true),
                            .media,
                            .findMessage,
                            .theme,
                            .deleteChatHistory
                        ]
                    }
                }()
            )

            let contentType = ChatSettingContentModel(
                headerType: headerType,
                itemModel: itemModel,
                isLeaveEnabled: true
            )
            return contentType
        case .unknown:
            return nil
        }
    }
}
