//
//  StorableMessage.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation
import RealmSwift

final class StorableMessage: Object {
    @Persisted(primaryKey: true) var primaryKey: String
    @Persisted var id: Int?
    @Persisted var localID: String?
    @Persisted var conversationID: Int?
    @Persisted var message: String?
    @Persisted var type: String?
    @Persisted var sender: StorableUser?
    @Persisted var leftParticipants: List<StorableUser>
    @Persisted var joinParticipants: List<StorableUser>
    @Persisted var seenBy = List<String>()
    @Persisted var attachments = List<StorableAttachment>()
    @Persisted var reactions = List<StorableMessageReaction>()
    @Persisted var createdAt: Date?
    @Persisted var isDeleted: Bool
    @Persisted var shareMessage: StorableMessage?
    @Persisted var replyToMessage: StorableMessage?
    
    var model: Message? {
        guard let conversationID,
              let type = type.flatMap({ MessageType(rawValue: $0) }),
              let sender = sender?.model,
              let createdAt else {
            return nil
        }
        return Message(
            id: id,
            localID: localID,
            conversationID: conversationID,
            message: message,
            type: type,
            sender: sender,
            leftParticipants: leftParticipants.compactMap { $0.model },
            joinParticipants: joinParticipants.compactMap { $0.model },
            seenBy: seenBy.map { $0 },
            attachments: attachments.compactMap { $0.model },
            reactions: reactions.compactMap { $0.model },
            createdAt: createdAt,
            isDeleted: isDeleted,
            shareMessage: shareMessage?.model,
            replyToMessage: replyToMessage?.model
        )
    }
    
    required convenience init(primaryKey: String?, model: Message) {
        self.init()
        self.primaryKey = primaryKey ?? UUID().uuidString
        self.id = model.id
        self.localID = model.localID
        self.conversationID = model.conversationID
        self.message = model.message
        self.type = model.type.rawValue
        self.sender = StorableUser(model.sender)
        self.leftParticipants = {
            let list = List<StorableUser>()
            list.append(objectsIn: model.leftParticipants.map { StorableUser($0) })
            return list
        }()
        self.joinParticipants = {
            let list = List<StorableUser>()
            list.append(objectsIn: model.joinParticipants.map { StorableUser($0) })
            return list
        }()
        self.seenBy = {
            let list = List<String>()
            list.append(objectsIn: model.seenBy)
            return list
        }()
        self.attachments = {
            let list = List<StorableAttachment>()
            list.append(objectsIn: model.attachments.map { StorableAttachment($0) })
            return list
        }()
        self.reactions = {
            let list = List<StorableMessageReaction>()
            list.append(objectsIn: model.reactions.map { StorableMessageReaction($0) })
            return list
        }()
        self.createdAt = model.createdAt
        self.isDeleted = model.isDeleted
        self.shareMessage = model.shareMessage
            .flatMap {
                StorableMessage(
                    primaryKey: $0.id.flatMap { String($0) },
                    model: $0
                )
            }
        self.replyToMessage = model.replyToMessage
            .flatMap {
                StorableMessage(
                    primaryKey: $0.id.flatMap { String($0) },
                    model: $0
                )
            }
    }

    required convenience init(param: SendMessageParam) {
        self.init()
        self.primaryKey = UUID().uuidString
        self.id = nil
        self.localID = param.localID
        self.conversationID = param.conversationID
        self.message = param.message
        self.type = param.type.rawValue
        self.sender = StorableUser(param.currentUser)
        self.leftParticipants = List<StorableUser>()
        self.joinParticipants = List<StorableUser>()
        self.seenBy = List<String>()
        self.attachments = {
            let list = List<StorableAttachment>()
            list.append(
                objectsIn: param.attachments?.map { StorableAttachment(param: $0) } ?? []
            )
            return list
        }()
        self.reactions = List<StorableMessageReaction>()
        self.createdAt = Date()
        self.isDeleted = false
        self.shareMessage = param.shareMessage
            .flatMap {
                StorableMessage(
                    primaryKey: $0.id.flatMap { String($0) },
                    model: $0
                )
            }
        self.replyToMessage = param.replyToMessage
            .flatMap {
                StorableMessage(
                    primaryKey: $0.id.flatMap { String($0) },
                    model: $0
                )
            }
    }

    override static func primaryKey() -> String? {
        "primaryKey"
    }
}
