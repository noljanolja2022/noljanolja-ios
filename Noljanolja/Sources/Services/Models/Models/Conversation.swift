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
    let createdAt: String
    let updatedAt: String
}
