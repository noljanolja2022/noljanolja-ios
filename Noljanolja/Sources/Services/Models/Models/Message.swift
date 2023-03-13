//
//  Message.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation

// MARK: - MessageType

enum MessageType: String, Codable {
    case plaintext = "PLAINTEXT"
    case sticker = "STICKER"
    case gif = "GIF"
    case photo = "PHOTO"
    case document = "DOCUMENT"
}

// MARK: - Message

struct Message: Equatable, Codable {
    let id: Int
    let conversationID: Int
    let message: String?
    let type: MessageType
    let sender: User
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case conversationID = "conversationId"
        case message
        case type
        case sender
        case createdAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.conversationID = try container.decode(Int.self, forKey: .conversationID)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.type = try container.decode(MessageType.self, forKey: .type)
        self.sender = try container.decode(User.self, forKey: .sender)
        if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt),
           let createdAt = createdAtString.date(withFormats: NetworkConfigs.Format.apiDateFormats) {
            self.createdAt = createdAt
        } else {
            throw NetworkError.mapping("\(Swift.type(of: type)) at key createdAt")
        }
    }

    init(id: Int,
         conversationID: Int,
         message: String?,
         type: MessageType,
         sender: User,
         createdAt: Date) {
        self.id = id
        self.conversationID = conversationID
        self.message = message
        self.type = type
        self.sender = sender
        self.createdAt = createdAt
    }
}
