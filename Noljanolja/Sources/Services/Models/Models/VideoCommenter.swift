//
//  VideoCommenter.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import Foundation

struct VideoCommenter: Equatable, Codable {
    let name: String?
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case name
        case avatar
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
    }
}
