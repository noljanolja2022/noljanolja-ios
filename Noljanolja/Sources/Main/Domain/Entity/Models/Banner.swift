//
//  Banner.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/06/2023.
//

import Foundation

// MARK: - BannerPriority

enum BannerPriority: String, Decodable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
    case urgent = "URGENT"
}

// MARK: - BannerActionType

enum BannerActionType: String, Decodable {
    case empty = "NONE"
    case link = "LINK"
    case share = "SHARE"
    case checkin = "CHECKIN"

    var title: String {
        switch self {
        case .empty: return ""
        case .link: return L10n.openLink
        case .share: return L10n.commonShare
        case .checkin: return L10n.walletCheckin
        }
    }
}

// MARK: - Banner

struct Banner: Equatable, Decodable {
    let id: Int
    let title: String?
    let description: String?
    let content: String?
    let image: String?
    let isActive: Bool
    let priority: BannerPriority
    let action: BannerActionType?
    let startTime: Date?
    let endTime: Date?

    init(id: Int,
         title: String?,
         description: String?,
         content: String?,
         image: String?,
         isActive: Bool,
         priority: BannerPriority,
         action: BannerActionType,
         startTime: Date,
         endTime: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.content = content
        self.image = image
        self.isActive = isActive
        self.priority = priority
        self.action = action
        self.startTime = startTime
        self.endTime = endTime
    }

    enum CodingKeys: CodingKey {
        case id
        case title
        case description
        case content
        case image
        case isActive
        case priority
        case action
        case startTime
        case endTime
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
        self.priority = try container.decodeIfPresent(BannerPriority.self, forKey: .priority) ?? .low
        self.action = try container.decodeIfPresent(BannerActionType.self, forKey: .action)

        let startTimeString = try container.decodeIfPresent(String.self, forKey: .startTime)
        self.startTime = startTimeString?.date(withFormats: NetworkConfigs.Format.apiFullDateFormats)

        let endTimeString = try container.decodeIfPresent(String.self, forKey: .endTime)
        self.endTime = endTimeString?.date(withFormats: NetworkConfigs.Format.apiFullDateFormats)
    }
}
