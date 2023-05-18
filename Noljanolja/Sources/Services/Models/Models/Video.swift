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
    let durationMs: Int?
    let viewCount: Int?
    let likeCount: Int?
    let commentCount: Int?
    let favoriteCount: Int?
    let isHighlighted: Bool?
    let comments: [VideoComment]
    let channel: VideoChannel?
    let category: VideoCategory?

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case publishedAt
        case title
        case thumbnail
        case duration
        case durationMs
        case viewCount
        case likeCount
        case commentCount
        case favoriteCount
        case isHighlighted
        case comments
        case channel
        case category
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
        self.durationMs = try container.decodeIfPresent(Int.self, forKey: .durationMs)
        self.viewCount = try container.decodeIfPresent(Int.self, forKey: .viewCount)
        self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
        self.commentCount = try container.decodeIfPresent(Int.self, forKey: .commentCount)
        self.favoriteCount = try container.decodeIfPresent(Int.self, forKey: .favoriteCount)
        self.isHighlighted = try container.decodeIfPresent(Bool.self, forKey: .isHighlighted)
        self.comments = try container.decodeIfPresent([VideoComment].self, forKey: .comments) ?? []
        self.channel = try container.decodeIfPresent(VideoChannel.self, forKey: .channel)
        self.category = try container.decodeIfPresent(VideoCategory.self, forKey: .category)
    }
}
