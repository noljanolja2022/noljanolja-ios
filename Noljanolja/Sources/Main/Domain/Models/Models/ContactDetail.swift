//
//  ContactDetail.swift
//  Noljanolja
//
//  Created by duydinhv on 05/01/2024.
//

import Foundation

// MARK: - TransferType

enum TransferType: String, Codable, CaseIterable {
    case request = "REQUEST"
    case send = "SEND"
}

// MARK: - ContactDetail

struct ContactDetail: Equatable, Codable {
    let id: String
    let name: String?
    let avatar: String?
    let phone: String
    let availablePoints: Int
    let userTransferPoint: UserTransferPoint?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.availablePoints = try container.decode(Int.self, forKey: .availablePoints)
        self.userTransferPoint = try container.decodeIfPresent(UserTransferPoint.self, forKey: .userTransferPoint)
    }
}

// MARK: - UserTransferPoint

struct UserTransferPoint: Equatable, Codable {
    let id: Int
    let fromUserId: String
    let toUserId: String
    let points: Int
    let type: TransferType
    let createdAt: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.fromUserId = try container.decode(String.self, forKey: .fromUserId)
        self.toUserId = try container.decode(String.self, forKey: .toUserId)
        self.points = try container.decode(Int.self, forKey: .points)
        self.type = try container.decode(TransferType.self, forKey: .type)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
    }
}
