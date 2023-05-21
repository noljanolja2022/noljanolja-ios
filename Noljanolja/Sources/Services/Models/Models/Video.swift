//
//  Video.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import Foundation

struct Video: Equatable, Codable {
    let id: String
    let url: String
    let publishedAt: Date
    let title: String?
    let thumbnail: String?
    let duration: String?
    let durationMs: Int
    let currentProgress: Int
    let viewCount: Int
    let likeCount: Int
    let commentCount: Int
    let favoriteCount: Int
    let isHighlighted: Bool
    let comments: [VideoComment]
    let channel: VideoChannel?
    let category: VideoCategory?
    let earnedPoints: Int
    let totalPoints: Int
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case publishedAt
        case title
        case thumbnail
        case duration
        case durationMs
        case currentProgress
        case viewCount
        case likeCount
        case commentCount
        case favoriteCount
        case isHighlighted
        case comments
        case channel
        case category
        case earnedPoints
        case totalPoints
        case completed
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.url = try container.decode(String.self, forKey: .url)
        if let publishedAtString = try container.decodeIfPresent(String.self, forKey: .publishedAt),
           let publishedAt = publishedAtString.date(withFormats: NetworkConfigs.Format.apiFullDateFormats) {
            self.publishedAt = publishedAt
        } else {
            throw DecodingError.valueNotFound(
                String.self,
                DecodingError.Context(
                    codingPath: container.codingPath + [CodingKeys.publishedAt],
                    debugDescription: ""
                )
            )
        }
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        self.duration = try container.decodeIfPresent(String.self, forKey: .duration)
        self.durationMs = try container.decodeIfPresent(Int.self, forKey: .durationMs) ?? 0
        self.currentProgress = try container.decodeIfPresent(Int.self, forKey: .durationMs) ?? 0
        self.viewCount = try container.decodeIfPresent(Int.self, forKey: .viewCount) ?? 0
        self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount) ?? 0
        self.commentCount = try container.decodeIfPresent(Int.self, forKey: .commentCount) ?? 0
        self.favoriteCount = try container.decodeIfPresent(Int.self, forKey: .favoriteCount) ?? 0
        self.isHighlighted = try container.decodeIfPresent(Bool.self, forKey: .isHighlighted) ?? false
        self.comments = try container.decodeIfPresent([VideoComment].self, forKey: .comments) ?? []
        self.channel = try container.decodeIfPresent(VideoChannel.self, forKey: .channel)
        self.category = try container.decodeIfPresent(VideoCategory.self, forKey: .category)
        self.earnedPoints = try container.decodeIfPresent(Int.self, forKey: .earnedPoints) ?? 0
        self.totalPoints = try container.decodeIfPresent(Int.self, forKey: .totalPoints) ?? 0
        self.completed = try container.decodeIfPresent(Bool.self, forKey: .completed) ?? false
    }
}
