//
//  VideoAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import Combine
import Foundation
import Moya

// MARK: - VideoAPITargets

private enum VideoAPITargets {
    struct GetVideos: BaseAuthTargetType {
        var path: String { "v1/media/videos" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        let page: Int
        let pageSize: Int?
        let isHighlighted: Bool?
        let categoryId: String?

        var parameters: [String: Any] {
            let parameters: [String: Any?] = [
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

        var parameters: [String: Any] {
            [
                "comment": comment
            ]
        }
    }

    struct LikeVideo: BaseAuthTargetType {
        var path: String { "v1/media/videos/\(videoId)/likes" }
        let method: Moya.Method = .post
        var task: Task { .requestParameters(parameters: [:], encoding: JSONEncoding.default) }

        let videoId: String
    }
}

// MARK: - VideoAPIType

protocol VideoAPIType {
    func getVideos(page: Int, pageSize: Int?, isHighlighted: Bool?, categoryId: String?) -> AnyPublisher<[Video], Error>
    func getWatchingVideos() -> AnyPublisher<[Video], Error>
    func getTrendingVideos(duration: VideoTrendingDurationType, limit: Int?) -> AnyPublisher<[Video], Error>

    func getVideoDetail(id: String) -> AnyPublisher<Video, Error>
    func getVideoComments(videoId: String, beforeCommentId: Int?, limit: Int?) -> AnyPublisher<[VideoComment], Error>
    func postVideoComment(videoId: String, comment: String) -> AnyPublisher<VideoComment, Error>
    func likeVideo(videoId: String) -> AnyPublisher<Void, Error>
}

extension VideoAPIType {
    func getVideos(page: Int, pageSize: Int? = nil, isHighlighted: Bool? = true, categoryId: String? = nil) -> AnyPublisher<[Video], Error> {
        getVideos(page: page, pageSize: pageSize, isHighlighted: isHighlighted, categoryId: categoryId)
    }

    func getTrendingVideos(duration: VideoTrendingDurationType, limit: Int? = nil) -> AnyPublisher<[Video], Error> {
        getTrendingVideos(duration: duration, limit: limit)
    }

    func getVideoComments(videoId: String, beforeCommentId: Int? = nil, limit: Int? = 20) -> AnyPublisher<[VideoComment], Error> {
        getVideoComments(videoId: videoId, beforeCommentId: beforeCommentId, limit: limit)
    }
}

// MARK: - VideoAPI

final class VideoAPI: VideoAPIType {
    static let `default` = VideoAPI()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getVideos(page: Int, pageSize: Int?, isHighlighted: Bool?, categoryId: String?) -> AnyPublisher<[Video], Error> {
        api.request(
            target: VideoAPITargets.GetVideos(
                page: page,
                pageSize: pageSize,
                isHighlighted: isHighlighted,
                categoryId: categoryId
            ),
            atKeyPath: "data"
        )
    }

    func getWatchingVideos() -> AnyPublisher<[Video], Error> {
        api.request(
            target: VideoAPITargets.WatchingVideos(),
            atKeyPath: "data"
        )
    }

    func getTrendingVideos(duration: VideoTrendingDurationType, limit: Int?) -> AnyPublisher<[Video], Error> {
        api.request(
            target: VideoAPITargets.GetTrendingVideos(duration: duration, limit: limit),
            atKeyPath: "data"
        )
    }

    func getVideoDetail(id: String) -> AnyPublisher<Video, Error> {
        api.request(
            target: VideoAPITargets.GetVideoDetail(videoId: id),
            atKeyPath: "data"
        )
    }

    func getVideoComments(videoId: String, beforeCommentId: Int?, limit: Int?) -> AnyPublisher<[VideoComment], Error> {
        api.request(
            target: VideoAPITargets.GetVideoComments(
                videoId: videoId,
                beforeCommentId: beforeCommentId,
                limit: limit
            ),
            atKeyPath: "data"
        )
    }

    func postVideoComment(videoId: String, comment: String) -> AnyPublisher<VideoComment, Error> {
        api.request(
            target: VideoAPITargets.PostVideoComments(
                videoId: videoId,
                comment: comment
            ),
            atKeyPath: "data"
        )
    }

    func likeVideo(videoId: String) -> AnyPublisher<Void, Error> {
        api.request(
            target: VideoAPITargets.LikeVideo(videoId: videoId)
        )
    }
}
