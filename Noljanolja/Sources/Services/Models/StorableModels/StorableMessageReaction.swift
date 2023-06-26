//
//  StorableMessageReaction.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/06/2023.
//

import Foundation
import RealmSwift

// MARK: - StorableUser

final class StorableMessageReaction: Object {
    @Persisted var reactionId: Int
    @Persisted var reactionCode: String
    @Persisted var reactionDescription: String?
    @Persisted var userId: String
    @Persisted var userName: String

    var model: MessageReaction? {
        MessageReaction(
            reactionId: reactionId,
            reactionCode: reactionCode,
            reactionDescription: reactionDescription,
            userId: userId,
            userName: userName
        )
    }

    required convenience init(_ model: MessageReaction) {
        self.init()
        self.reactionId = model.reactionId
        self.reactionCode = model.reactionCode
        self.reactionDescription = model.reactionDescription
        self.userId = model.userId
        self.userName = model.userName
    }
}
