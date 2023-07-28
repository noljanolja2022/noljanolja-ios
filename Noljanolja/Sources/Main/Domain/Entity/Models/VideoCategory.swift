//
//  VideoCatagory.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import Foundation

struct VideoCategory: Equatable, Codable {
    let id: String
    let title: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
    }

    init(id: String, title: String?) {
        self.id = id
        self.title = title
    }
}
