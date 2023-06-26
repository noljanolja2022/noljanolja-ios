//
//  MessageReaction.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/06/2023.
//

import Foundation

struct MessageReaction: Equatable, Codable {
    let reactionId: Int
    let reactionCode: String
    let reactionDescription: String?
    let userId: String
    let userName: String

    init(reactionId: Int, reactionCode: String, reactionDescription: String?, userId: String, userName: String) {
        self.reactionId = reactionId
        self.reactionCode = reactionCode
        self.reactionDescription = reactionDescription
        self.userId = userId
        self.userName = userName
    }

    enum CodingKeys: CodingKey {
        case reactionId
        case reactionCode
        case reactionDescription
        case userId
        case userName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.reactionId = try container.decode(Int.self, forKey: .reactionId)
        self.reactionCode = try container.decode(String.self, forKey: .reactionCode)
        self.reactionDescription = try container.decodeIfPresent(String.self, forKey: .reactionDescription)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.userName = try container.decode(String.self, forKey: .userName)
    }
}
