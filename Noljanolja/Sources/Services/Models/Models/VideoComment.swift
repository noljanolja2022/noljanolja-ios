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

    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case commenter
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self.commenter = try container.decodeIfPresent(VideoCommenter.self, forKey: .commenter)
    }
}
