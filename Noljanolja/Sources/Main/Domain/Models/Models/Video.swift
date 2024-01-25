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
    let publishedAt: Date?
    let title: String?
    let thumbnail: String?
    let duration: String?
    let durationMs: Int
    let currentProgressMs: Int
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
    let isLiked: Bool

    var likeCountString: String {
        let thousand = 1000
        let million = 1000000

        if likeCount < thousand {
            return "\(likeCount)"
        } else if likeCount < million {
            let roundedViews = Double(likeCount) / Double(thousand)
            return String(format: "%.1fK", roundedViews)
        } else {
            let roundedViews = Double(likeCount) / Double(million)
            return String(format: "%.1fM", roundedViews)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.url = try container.decode(String.self, forKey: .url)

        let publishedAtString = try container.decodeIfPresent(String.self, forKey: .publishedAt)
        self.publishedAt = publishedAtString?.date(withFormats: NetworkConfigs.Format.apiFullDateFormats)

        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        self.duration = try container.decodeIfPresent(String.self, forKey: .duration)
        self.durationMs = try container.decodeIfPresent(Int.self, forKey: .durationMs) ?? 0
        self.currentProgressMs = try container.decodeIfPresent(Int.self, forKey: .currentProgressMs) ?? 0
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
        self.isLiked = try container.decodeIfPresent(Bool.self, forKey: .isLiked) ?? false
    }

    init(id: String, url: String, publishedAt: Date?, title: String?, thumbnail: String?, duration: String?, durationMs: Int, currentProgressMs: Int, viewCount: Int, likeCount: Int, commentCount: Int, favoriteCount: Int, isHighlighted: Bool, comments: [VideoComment], channel: VideoChannel?, category: VideoCategory?, earnedPoints: Int, totalPoints: Int, completed: Bool, isLiked: Bool) {
        self.id = id
        self.url = url
        self.publishedAt = publishedAt
        self.title = title
        self.thumbnail = thumbnail
        self.duration = duration
        self.durationMs = durationMs
        self.currentProgressMs = currentProgressMs
        self.viewCount = viewCount
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.favoriteCount = favoriteCount
        self.isHighlighted = isHighlighted
        self.comments = comments
        self.channel = channel
        self.category = category
        self.earnedPoints = earnedPoints
        self.totalPoints = totalPoints
        self.completed = completed
        self.isLiked = isLiked
    }
}
