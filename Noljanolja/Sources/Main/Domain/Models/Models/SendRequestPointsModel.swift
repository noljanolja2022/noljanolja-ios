//
//  SendRequestPointsModel.swift
//  Noljanolja
//
//  Created by duydinhv on 05/01/2024.
//

import Foundation

struct SendRequestPointsModel: Equatable, Codable {
    let id: Int
    let fromUserId: String
    let toUserId: String
    let points: Int
    let type: TransferType
    let createdAt: String
    enum CodingKeys: String, CodingKey {
        case id
        case fromUserId
        case toUserId
        case points
        case type
        case createdAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.fromUserId = try container.decodeIfPresent(String.self, forKey: .fromUserId) ?? ""
        self.toUserId = try container.decodeIfPresent(String.self, forKey: .toUserId) ?? ""
        self.points = try container.decodeIfPresent(Int.self, forKey: .points) ?? 0
        self.type = try container.decode(TransferType.self, forKey: .type)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
    }
}
