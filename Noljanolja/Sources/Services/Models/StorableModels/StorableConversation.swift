//
//  StorableConversation.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation
import RealmSwift

final class StorableConversation: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String?
    @Persisted var creator: StorableUser?
    @Persisted var admin: StorableUser?
    @Persisted var type: String?
    @Persisted var messages = List<StorableMessage>()
    @Persisted var participants = List<StorableUser>()
    @Persisted var createdAt: Date?
    @Persisted var updatedAt: Date?

    var model: Conversation? {
        guard let creator = creator?.model,
              let admin = admin?.model,
              let type = type.flatMap({ ConversationType(rawValue: $0) }),
              let createdAt,
              let updatedAt else {
            return nil
        }
        return Conversation(
            id: id,
            title: title,
            creator: creator,
            admin: admin,
            type: type,
            messages: messages.compactMap { $0.model },
            participants: participants.compactMap { $0.model },
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    convenience init(_ model: Conversation) {
        self.init()
        self.id = model.id
        self.title = model.title
        self.creator = StorableUser(model.creator)
        self.admin = StorableUser(model.admin)
        self.type = model.type.rawValue
        self.messages = {
            let list = List<StorableMessage>()
            list.append(
                objectsIn: model.messages.map {
                    StorableMessage(primaryKey: $0.id.flatMap { String($0) }, model: $0)
                }
            )
            return list
        }()
        self.participants = {
            let list = List<StorableUser>()
            list.append(objectsIn: model.participants.map { StorableUser($0) })
            return list
        }()
        self.createdAt = model.createdAt
        self.updatedAt = model.updatedAt
    }
}
