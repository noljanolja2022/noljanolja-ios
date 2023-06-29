//
//  BannerRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/06/2023.
//

import Combine
import Foundation
import Moya

// MARK: - BannerTargets

private enum BannerTargets {
    struct GetBanners: BaseAuthTargetType {
        var path: String { "v1/banners" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.queryString) }

        let page: Int?
        let pageSize: Int?

        var parameters: [String: Any] {
            [
                "page": page,
                "pageSize": pageSize
            ]
            .compactMapValues { $0 }
        }
    }
}

// MARK: - BannerRepository

protocol BannerRepository {
    func getBanners(page: Int?, pageSize: Int?) -> AnyPublisher<PaginationResponse<[Banner]>, Error>
}

extension BannerRepository {
    func getBanners(page: Int? = nil, pageSize: Int? = nil) -> AnyPublisher<PaginationResponse<[Banner]>, Error> {
        getBanners(page: page, pageSize: pageSize)
    }
}

// MARK: - BannerRepositoryImpl

final class BannerRepositoryImpl: BannerRepository {
    static let shared = BannerRepositoryImpl()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getBanners(page: Int?, pageSize: Int?) -> AnyPublisher<PaginationResponse<[Banner]>, Error> {
        api.request(target: BannerTargets.GetBanners(page: page, pageSize: pageSize))
    }
}
