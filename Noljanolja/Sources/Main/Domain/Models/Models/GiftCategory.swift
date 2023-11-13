//
//  GiftCategory.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/06/2023.
//

import Foundation

struct GiftCategory: Equatable, Decodable {
    let id: Int
    let code: String
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case code
        case image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.code = try container.decode(String.self, forKey: .code)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
    }
}
