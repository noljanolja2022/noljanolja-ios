//
//  ConversationAttachment.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 30/08/2023.
//

import Foundation

struct ConversationAttachment: Equatable, Decodable {
    let id: String
    let messageId: Int
    let name: String
    let originalName: String
    let previewImage: String

    enum CodingKeys: CodingKey {
        case id
        case messageId
        case name
        case originalName
        case previewImage
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = String(try container.decode(Int.self, forKey: .id))
        self.messageId = try container.decode(Int.self, forKey: .messageId)
        self.name = try container.decode(String.self, forKey: .name)
        self.originalName = try container.decode(String.self, forKey: .originalName)
        self.previewImage = try container.decode(String.self, forKey: .previewImage)
    }

    func getPhotoURL(conversationID: Int) -> URL? {
        MessageService.default.getPhotoURL(conversationID: conversationID, attachmentId: id, fileName: nil)
    }
}
