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
    @Persisted var seenBy = List<String>()
    @Persisted var attachments = List<StorableAttachment>()
    @Persisted var createdAt: Date?
    
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
            seenBy: seenBy.map { $0 },
            attachments: attachments.compactMap { $0.model },
            createdAt: createdAt
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
        self.seenBy = {
            let list = List<String>()
            list.append(objectsIn: model.seenBy)
            return list
        }()
        self.attachments = {
            let list = List<StorableAttachment>()
            list.append(objectsIn: model.attachments.map { StorableAttachment(model: $0) })
            return list
        }()
        self.createdAt = model.createdAt
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
        self.seenBy = List<String>()
        self.attachments = {
            let list = List<StorableAttachment>()
            list.append(
                objectsIn: param.attachments?.map { StorableAttachment(param: $0) } ?? []
            )
            return list
        }()
        self.createdAt = Date()
    }
}
