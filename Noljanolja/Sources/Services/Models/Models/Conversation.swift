//
//  Conversation.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation

// MARK: - ConversationType

enum ConversationType: String, Codable {
    case single = "SINGLE"
    case group = "GROUP"
}

// MARK: - Conversation

struct Conversation: Equatable, Codable {
    let id: Int
    let title: String?
    let creator: User
    let type: ConversationType
    let messages: [Message]
    let participants: [User]
    let createdAt: Date
    let updatedAt: Date

    init(id: Int,
         title: String?,
         creator: User,
         type: ConversationType,
         messages: [Message],
         participants: [User],
         createdAt: Date,
         updatedAt: Date) {
        self.id = id
        self.title = title
        self.creator = creator
        self.type = type
        self.messages = messages
        self.participants = participants
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.creator = try container.decode(User.self, forKey: .creator)
        self.type = try container.decode(ConversationType.self, forKey: .type)
        self.messages = try container.decodeIfPresent([Message].self, forKey: .messages) ?? []
        self.participants = try container.decode([User].self, forKey: .participants)

        if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt),
           let createdAt = createdAtString.date(withFormats: NetworkConfigs.Format.apiFullDateFormats) {
            self.createdAt = createdAt
        } else {
            throw NetworkError.mapping("\(String(describing: Swift.type(of: self))) at key createdAt")
        }

        if let updatedAtString = try container.decodeIfPresent(String.self, forKey: .updatedAt),
           let updatedAt = updatedAtString.date(withFormats: NetworkConfigs.Format.apiFullDateFormats) {
            self.updatedAt = updatedAt
        } else {
            throw NetworkError.mapping("\(String(describing: Swift.type(of: self))) at key updatedAt")
        }
    }
}
