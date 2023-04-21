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
}

// MARK: - VideoAPIType

protocol VideoAPIType {
    func getVideos(page: Int, pageSize: Int?, isHighlighted: Bool?, categoryId: String?) -> AnyPublisher<[Video], Error>
    func getTrendingVideos(duration: VideoTrendingDurationType, limit: Int?) -> AnyPublisher<[Video], Error>
}

extension VideoAPIType {
    func getVideos(page: Int, pageSize: Int? = nil, isHighlighted: Bool? = true, categoryId: String? = nil) -> AnyPublisher<[Video], Error> {
        getVideos(page: page, pageSize: pageSize, isHighlighted: isHighlighted, categoryId: categoryId)
    }

    func getTrendingVideos(duration: VideoTrendingDurationType, limit: Int? = nil) -> AnyPublisher<[Video], Error> {
        getTrendingVideos(duration: duration, limit: limit)
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

    func getTrendingVideos(duration: VideoTrendingDurationType, limit: Int?) -> AnyPublisher<[Video], Error> {
        api.request(
            target: VideoAPITargets.GetTrendingVideos(duration: duration, limit: limit),
            atKeyPath: "data"
        )
    }
}
