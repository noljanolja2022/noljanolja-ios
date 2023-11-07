//
//  Attachment.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 24/03/2023.
//

import Foundation

struct Attachment: Equatable, Codable {
    let id: String
    let messageID: Int?
    let name: String?
    let originalName: String?
    let size: Double?
    let type: String?
    let md5: String?

    enum CodingKeys: String, CodingKey {
        case id
        case messageID = "messageId"
        case name
        case originalName
        case size
        case type
        case md5
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = String(try container.decode(Int.self, forKey: .id))
        self.messageID = try container.decodeIfPresent(Int.self, forKey: .messageID)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.originalName = try container.decodeIfPresent(String.self, forKey: .originalName)
        self.size = try container.decodeIfPresent(Double.self, forKey: .size)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.md5 = try container.decodeIfPresent(String.self, forKey: .md5)
    }

    init(id: String, messageID: Int?, name: String?, originalName: String?, size: Double?, type: String?, md5: String?) {
        self.id = id
        self.messageID = messageID
        self.name = name
        self.originalName = originalName
        self.size = size
        self.type = type
        self.md5 = md5
    }

    func getPhotoURL(conversationID: Int) -> URL? {
        MessageUseCasesImpl.default.getPhotoURL(conversationID: conversationID, attachmentId: id, fileName: originalName)
    }
}
