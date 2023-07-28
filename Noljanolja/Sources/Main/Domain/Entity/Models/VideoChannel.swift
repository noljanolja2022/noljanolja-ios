//
//  VideoChannel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import Foundation

struct VideoChannel: Equatable, Codable {
    let id: String
    let title: String?
    let thumbnail: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case thumbnail
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
    }

    init(id: String, title: String?, thumbnail: String?) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
    }
}
