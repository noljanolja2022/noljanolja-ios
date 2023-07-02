//
//  StorableAttachment.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 24/03/2023.
//

import Foundation
import RealmSwift

final class StorableAttachment: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var messageID: Int?
    @Persisted var name: String?
    @Persisted var originalName: String?
    @Persisted var size: Double?
    @Persisted var type: String?
    @Persisted var md5: String?

    var model: Attachment? {
        Attachment(
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
        self.id = String(model.id)
        self.messageID = model.messageID
        self.name = model.name
        self.originalName = model.originalName
        self.size = model.size
        self.type = model.type
        self.md5 = model.md5
    }

    required convenience init(param: AttachmentParam) {
        self.init()
        self.id = UUID().uuidString
        self.messageID = nil
        self.name = nil
        self.originalName = param.name
        self.size = nil
        self.type = nil
        self.md5 = nil
    }

    override static func primaryKey() -> String? {
        "id"
    }
}
