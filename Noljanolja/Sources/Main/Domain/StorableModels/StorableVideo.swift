//
//  StorableVideo.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/07/2023.
//

import Foundation
import RealmSwift

final class StorableVideo: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var url: String
    @Persisted var publishedAt: Date?
    @Persisted var title: String?
    @Persisted var thumbnail: String?
    @Persisted var duration: String?
    @Persisted var durationMs: Int
    @Persisted var currentProgressMs: Int
    @Persisted var viewCount: Int
    @Persisted var likeCount: Int
    @Persisted var commentCount: Int
    @Persisted var favoriteCount: Int
    @Persisted var isHighlighted: Bool
    @Persisted var comments: List<StorableVideoComment>
    @Persisted var channel: StorableVideoChannel?
    @Persisted var category: StorableVideoCategory?
    @Persisted var earnedPoints: Int
    @Persisted var totalPoints: Int
    @Persisted var completed: Bool
    @Persisted var isLiked: Bool

    var model: Video? {
        Video(
            id: id,
            url: url,
            publishedAt: publishedAt,
            title: title,
            thumbnail: thumbnail,
            duration: duration,
            durationMs: durationMs,
            currentProgressMs: currentProgressMs,
            viewCount: viewCount,
            likeCount: likeCount,
            commentCount: commentCount,
            favoriteCount: favoriteCount,
            isHighlighted: isHighlighted,
            comments: comments.compactMap { $0.model },
            channel: channel?.model,
            category: category?.model,
            earnedPoints: earnedPoints,
            totalPoints: totalPoints,
            completed: completed,
            isLiked: isLiked
        )
    }

    required convenience init(_ model: Video) {
        self.init()
        self.id = model.id
        self.url = model.url
        self.publishedAt = model.publishedAt
        self.title = model.title
        self.thumbnail = model.thumbnail
        self.duration = model.duration
        self.durationMs = model.durationMs
        self.currentProgressMs = model.currentProgressMs
        self.viewCount = model.viewCount
        self.likeCount = model.likeCount
        self.commentCount = model.commentCount
        self.favoriteCount = model.favoriteCount
        self.isHighlighted = model.isHighlighted
        self.comments = {
            let list = List<StorableVideoComment>()
            list.append(objectsIn: model.comments.map { StorableVideoComment($0) })
            return list
        }()
        self.channel = model.channel.flatMap { StorableVideoChannel($0) }
        self.category = model.category.flatMap { StorableVideoCategory($0) }
        self.earnedPoints = model.earnedPoints
        self.totalPoints = model.totalPoints
        self.completed = model.completed
        self.isLiked = model.isLiked
    }

    override static func primaryKey() -> String? {
        "id"
    }
}
