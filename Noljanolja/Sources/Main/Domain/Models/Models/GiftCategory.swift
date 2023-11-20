//
//  GiftCategory.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/06/2023.
//

import Foundation

// MARK: - GiftCategory

struct GiftCategory: Equatable, Decodable {
    let id: Int
    let name: String
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
    }

    init(id: Int, name: String) {
        self.name = name
        self.id = id
        self.image = nil
    }
}
