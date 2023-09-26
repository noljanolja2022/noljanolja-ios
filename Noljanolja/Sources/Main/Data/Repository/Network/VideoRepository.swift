//
//  VideoRepositoryImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import Combine
import Foundation
import Moya

// MARK: - VideoTargets

private enum VideoTargets {
    struct GetVideos: BaseAuthTargetType {
        var path: String { "v1/media/videos" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        let query: String?
        let page: Int
        let pageSize: Int?
        let isHighlighted: Bool?
        let categoryId: String?

        var parameters: [String: Any] {
            let parameters: [String: Any?] = [
                "query": query,
                "page": page,
                "pageSize": pageSize,
                "isHighlighted": isHighlighted,
                "categoryId": categoryId
            ]
            return parameters.compactMapValues { $0 }
        }
    }

    struct WatchingVideos: BaseAuthTargetType {
        var path: String { "v1/media/videos/watching" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }
    }

    struct GetTrendingVideos: BaseAuthTargetType {
        var path: String { "v1/media/videos/trending" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        let duration: VideoTrendingDurationType
        let limit: Int?

        var parameters: [String: Any] {
            let parameters: [String: Any?] = [
                "duration": duration.rawValue,
                "limit": limit
            ]
            return parameters.compactMapValues { $0 }
        }
    }

    struct GetPromotedVideos: BaseAuthTargetType {
        var path: String { "v1/media/videos/promoted" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        let page: Int
        let pageSize: Int

        var parameters: [String: Any] {
            [
                "page": page,
                "pageSize": pageSize
            ]
        }
    }

    struct GetVideoDetail: BaseAuthTargetType {
        var path: String { "v1/media/videos/\(videoId)" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }

        let videoId: String
    }

    struct GetVideoComments: BaseAuthTargetType {
        var path: String { "v1/media/videos/\(videoId)/comments" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        let videoId: String
        let beforeCommentId: Int?
        let limit: Int?

        var parameters: [String: Any] {
            let parameters: [String: Any?] = [
                "beforeCommentId": beforeCommentId,
                "limit": limit
            ]
            return parameters.compactMapValues { $0 }
        }
    }

    struct PostVideoComments: BaseAuthTargetType {
        var path: String { "v1/media/videos/\(videoId)/comments" }
        let method: Moya.Method = .post
        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }

        let videoId: String
        let comment: String
        let youtubeToken: String

        var parameters: [String: Any] {
            [
                "comment": comment,
                "youtubeToken": youtubeToken
            ]
        }
    }

    struct LikeVideo: BaseAuthTargetType {
        var path: String { "v1/media/videos/\(videoId)/likes" }
        let method: Moya.Method = .post
        var task: Task { .requestParameters(parameters: [:], encoding: JSONEncoding.default) }

        let videoId: String
    }

    struct ReactPromote: BaseAuthTargetType {
        var path: String { "v1/media/videos/\(videoId)/react-promote" }
        let method: Moya.Method = .post
        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }

        let videoId: String
        let youtubeToken: String

        var parameters: [String: Any] {
            [
                "youtubeToken": youtubeToken
            ]
        }
    }
}

// MARK: - VideoRepository

protocol VideoRepository {
    func getVideos(query: String?,
                   page: Int,
                   pageSize: Int?,
                   isHighlighted: Bool?,
                   categoryId: String?) -> AnyPublisher<PaginationResponse<[Video]>, Error>
    func getWatchingVideos() -> AnyPublisher<[Video], Error>
    func getTrendingVideos(duration: VideoTrendingDurationType, limit: Int?) -> AnyPublisher<[Video], Error>
    func getPromotedVideos(page: Int, pageSize: Int) -> AnyPublisher<[PromotedVideo], Error>

    func getVideoDetail(id: String) -> AnyPublisher<Video, Error>
    func getVideoComments(videoId: String, beforeCommentId: Int?, limit: Int?) -> AnyPublisher<[VideoComment], Error>
    func postVideoComment(videoId: String, comment: String, youtubeToken: String) -> AnyPublisher<VideoComment, Error>
    func likeVideo(videoId: String) -> AnyPublisher<Void, Error>
    func reactPromote(videoId: String, youtubeToken: String) -> AnyPublisher<Void, Error>
}

extension VideoRepository {
    func getVideos(query: String? = nil,
                   page: Int,
                   pageSize: Int? = nil,
                   isHighlighted: Bool? = nil,
                   categoryId: String? = nil) -> AnyPublisher<PaginationResponse<[Video]>, Error> {
        getVideos(query: query, page: page, pageSize: pageSize, isHighlighted: isHighlighted, categoryId: categoryId)
    }

    func getTrendingVideos(duration: VideoTrendingDurationType, limit: Int? = nil) -> AnyPublisher<[Video], Error> {
        getTrendingVideos(duration: duration, limit: limit)
    }

    func getVideoComments(videoId: String, beforeCommentId: Int? = nil, limit: Int? = 20) -> AnyPublisher<[VideoComment], Error> {
        getVideoComments(videoId: videoId, beforeCommentId: beforeCommentId, limit: limit)
    }
}

// MARK: - VideoRepositoryImpl

final class VideoRepositoryImpl: VideoRepository {
    static let shared = VideoRepositoryImpl()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getVideos(query: String?,
                   page: Int,
                   pageSize: Int?,
                   isHighlighted: Bool?,
                   categoryId: String?) -> AnyPublisher<PaginationResponse<[Video]>, Error> {
        api.request(
            target: VideoTargets.GetVideos(
                query: query,
                page: page,
                pageSize: pageSize,
                isHighlighted: isHighlighted,
                categoryId: categoryId
            )
        )
    }

    func getWatchingVideos() -> AnyPublisher<[Video], Error> {
        api.request(
            target: VideoTargets.WatchingVideos(),
            atKeyPath: "data"
        )
    }

    func getTrendingVideos(duration: VideoTrendingDurationType, limit: Int?) -> AnyPublisher<[Video], Error> {
        api.request(
            target: VideoTargets.GetTrendingVideos(duration: duration, limit: limit),
            atKeyPath: "data"
        )
    }

    func getPromotedVideos(page: Int, pageSize: Int) -> AnyPublisher<[PromotedVideo], Error> {
        api.request(
            target: VideoTargets.GetPromotedVideos(page: page, pageSize: pageSize),
            atKeyPath: "data"
        )
    }

    func getVideoDetail(id: String) -> AnyPublisher<Video, Error> {
        api.request(
            target: VideoTargets.GetVideoDetail(videoId: id),
            atKeyPath: "data"
        )
    }

    func getVideoComments(videoId: String, beforeCommentId: Int?, limit: Int?) -> AnyPublisher<[VideoComment], Error> {
        api.request(
            target: VideoTargets.GetVideoComments(
                videoId: videoId,
                beforeCommentId: beforeCommentId,
                limit: limit
            ),
            atKeyPath: "data"
        )
    }

    func postVideoComment(videoId: String, comment: String, youtubeToken: String) -> AnyPublisher<VideoComment, Error> {
        api.request(
            target: VideoTargets.PostVideoComments(
                videoId: videoId,
                comment: comment,
                youtubeToken: youtubeToken
            ),
            atKeyPath: "data"
        )
    }

    func likeVideo(videoId: String) -> AnyPublisher<Void, Error> {
        api.request(
            target: VideoTargets.LikeVideo(videoId: videoId)
        )
    }

    func reactPromote(videoId: String, youtubeToken: String) -> AnyPublisher<Void, Error> {
        api.request(
            target: VideoTargets.ReactPromote(videoId: videoId, youtubeToken: youtubeToken)
        )
    }
}
