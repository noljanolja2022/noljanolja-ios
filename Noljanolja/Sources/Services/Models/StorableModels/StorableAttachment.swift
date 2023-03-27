//
//  StorableAttachment.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 24/03/2023.
//

import Foundation
import RealmSwift

final class StorableAttachment: Object, StorableModel {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var messageID: Int?
    @Persisted var name: String?
    @Persisted var originalName: String?
    @Persisted var size: Double?
    @Persisted var type: String?
    @Persisted var md5: String?

    var model: Attachment? {
        guard let messageID else {
            return nil
        }
        return Attachment(
            id: id,
            messageID: messageID,
            name: name,
            originalName: originalName,
            size: size,
            type: type,
            md5: md5
        )
    }

    required convenience init(_ model: Attachment) {
        self.init()
        self.id = model.id
        self.messageID = model.messageID
        self.name = model.name
        self.originalName = model.originalName
        self.size = size
        self.type = type
        self.md5 = model.md5
    }
}
