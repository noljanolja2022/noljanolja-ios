//
//  VideoComment.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import Foundation

struct VideoComment: Equatable, Codable {
    let id: Int
    let comment: String?
    let commenter: VideoCommenter?
    let createdAt: Date?
    let updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case commenter
        case createdAt
        case updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self.commenter = try container.decodeIfPresent(VideoCommenter.self, forKey: .commenter)

        let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.createdAt = createdAtString?.date(withFormats: NetworkConfigs.Format.apiFullDateFormats)

        let updatedAtString = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        self.updatedAt = updatedAtString?.date(withFormats: NetworkConfigs.Format.apiFullDateFormats)
    }

    init(id: Int, comment: String?, commenter: VideoCommenter?, createdAt: Date?, updatedAt: Date?) {
        self.id = id
        self.comment = comment
        self.commenter = commenter
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
