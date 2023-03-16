//
//  StorableConversation.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation
import RealmSwift

final class StorableConversation: Object, StorableModel {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String?
    @Persisted var creator: StorableUser?
    @Persisted var type: String?
    @Persisted var messages = List<StorableMessage>()
    @Persisted var participants = List<StorableUser>()
    @Persisted var createdAt: Date?
    @Persisted var updatedAt: Date?

    var model: Conversation? {
        guard let creator = creator?.model,
              let type = type.flatMap({ ConversationType(rawValue: $0) }),
              let createdAt else {
            return nil
        }
        return Conversation(
            id: id,
            title: title,
            creator: creator,
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
        self.type = model.type.rawValue
        self.messages = {
            let messagesList = List<StorableMessage>()
            let storableMessages = model.messages.map { StorableMessage($0) }
            messagesList.append(objectsIn: storableMessages)
            return messagesList
        }()
        self.participants = {
            let participantsList = List<StorableUser>()
            let storableParticipants = model.participants.map { StorableUser($0) }
            participantsList.append(objectsIn: storableParticipants)
            return participantsList
        }()
        self.createdAt = model.createdAt
        self.updatedAt = model.updatedAt
    }
}
