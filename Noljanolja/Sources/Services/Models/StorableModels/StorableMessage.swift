//
//  StorableMessage.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation
import RealmSwift

final class StorableMessage: Object, StorableModel {
    @Persisted(primaryKey: true) var id: Int
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
            conversationID: conversationID,
            message: message,
            type: type,
            sender: sender,
            seenBy: seenBy.map { $0 },
            attachments: attachments.compactMap { $0.model },
            createdAt: createdAt
        )
    }
    
    required convenience init(_ model: Message) {
        self.init()
        self.id = model.id
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
            list.append(objectsIn: model.attachments.map { StorableAttachment($0) })
            return list
        }()
        self.createdAt = model.createdAt
    }
}
