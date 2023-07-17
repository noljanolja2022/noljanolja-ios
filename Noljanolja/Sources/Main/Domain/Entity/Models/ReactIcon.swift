//
//  ReactIcon.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/06/2023.
//

import Foundation

struct ReactIcon: Equatable, Hashable, Decodable {
    let id: Int
    let code: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case code
        case description
    }

    init(id: Int,
         code: String?,
         description: String?) {
        self.id = id
        self.code = code
        self.description = description
    }

    init(_ model: MessageReaction) {
        self.id = model.reactionId
        self.code = model.reactionCode
        self.description = model.reactionDescription
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.code = try container.decodeIfPresent(String.self, forKey: .code)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
    }
}
