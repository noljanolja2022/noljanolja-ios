//
//  NotificationsModel.swift
//  Noljanolja
//
//  Created by duydinhv on 12/01/2024.
//

import Foundation

// MARK: - NotificationType

enum NotificationType: String, Codable, CaseIterable {
    case requestPoint = "REQUEST_POINT"
    case sendPoint = "SEND_POINT"
}

// MARK: - NotificationsModel

struct NotificationsModel: Codable {
    var id: Int
    var type: NotificationType?
    var userID, title, body: String
    var image: String
    var isRead: Bool
    var createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case title, type, body, image, isRead, createdAt, updatedAt
    }
}
