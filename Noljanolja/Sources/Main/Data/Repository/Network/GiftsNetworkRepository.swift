//
//  GiftsNetworkRepositoryImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/06/2023.
//

import Combine
import Foundation
import Moya

// MARK: - GiftsTargets

#warning("update locale when BE update India market")

private enum GiftsTargets {
    struct GetMyGifts: BaseAuthTargetType {
        var path: String { "v1/gifts/me" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        let categoryId: Int?
        let brandId: Int?
        let page: Int
        let pageSize: Int?

        var parameters: [String: Any] {
            let parameters: [String: Any?] = [
                "categoryId": categoryId,
                "brandId": brandId,
                "page": page,
                "pageSize": pageSize,
            ]
            return parameters.compactMapValues { $0 }
        }
    }

    struct GetGiftsInShop: BaseAuthTargetType {
        var path: String { "v1/gifts" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        let categoryId: Int?
        let brandId: String?
        let query: String?
        let page: Int
        let pageSize: Int?
        let isFeatured: Bool?
        let isTodayOffer: Bool?
        let isRecommend: Bool?

        var parameters: [String: Any] {
            let parameters: [String: Any?] = [
                "categoryId": categoryId,
                "brandId": brandId,
                "query": query,
                "page": page,
                "pageSize": pageSize,
                "isFeatured": isFeatured,
                "isRecommend": isRecommend,
                "locale": "KR",
            ]
            return parameters.compactMapValues { $0 }
        }
    }

    struct GetGiftsBrands: BaseAuthTargetType {
        var path: String { "v1/gifts/brands" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        let page: Int
        let pageSize: Int

        var parameters: [String: Any] {
            let parameters: [String: Any?] = [
                "page": page,
                "pageSize": pageSize,
                "locale": "KR",
            ]
            return parameters.compactMapValues { $0 }
        }
    }

    struct GetGiftsCategories: BaseAuthTargetType {
        var path: String { "v1/gifts/categories" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        let page: Int
        let pageSize: Int

        var parameters: [String: Any] {
            let parameters: [String: Any?] = [
                "page": page,
                "pageSize": pageSize,
                "locale": "KR",
            ]
            return parameters.compactMapValues { $0 }
        }
    }

    struct BuyGift: BaseAuthTargetType {
        var path: String { "v1/gifts/\(giftId)/buy" }
        let method: Moya.Method = .post
        var task: Task { .requestPlain }

        let giftId: String
    }
}

// MARK: - GiftsNetworkRepository

protocol GiftsNetworkRepository {
    func getMyGifts(categoryId: Int?, brandId: Int?, page: Int, pageSize: Int?) -> AnyPublisher<PaginationResponse<[MyGift]>, Error>
    func getGiftsInShop(categoryId: Int?, brandId: String?, query: String?, page: Int, pageSize: Int?, isFeatured: Bool?, isTodayOffer: Bool?, isRecommend: Bool?) -> AnyPublisher<PaginationResponse<[Gift]>, Error>
    func getGiftsBrands(page: Int, pageSize: Int) -> AnyPublisher<PaginationResponse<[GiftBrand]>, Error>
    func getGiftsCategories(page: Int, pageSize: Int) -> AnyPublisher<PaginationResponse<[GiftCategory]>, Error>
    func buyGift(_ id: String) -> AnyPublisher<MyGift, Error>
}

extension GiftsNetworkRepository {
    func getMyGifts(categoryId: Int? = nil,
                    brandId: Int? = nil,
                    page: Int,
                    pageSize: Int? = nil) -> AnyPublisher<PaginationResponse<[MyGift]>, Error> {
        getMyGifts(categoryId: categoryId, brandId: brandId, page: page, pageSize: pageSize)
    }

    func getGiftsInShop(categoryId: Int? = nil,
                        brandId: String? = nil,
                        query: String? = nil,
                        page: Int = 1,
                        pageSize: Int? = nil,
                        isFeatured: Bool? = nil,
                        isTodayOffer: Bool? = nil,
                        isRecommend: Bool? = nil)
        -> AnyPublisher<PaginationResponse<[Gift]>, Error> {
        getGiftsInShop(categoryId: categoryId, brandId: brandId, query: query, page: page, pageSize: pageSize, isFeatured: isFeatured, isTodayOffer: isTodayOffer, isRecommend: isRecommend)
    }
}

// MARK: - GiftsNetworkRepositoryImpl

final class GiftsNetworkRepositoryImpl: GiftsNetworkRepository {
    static let `default` = GiftsNetworkRepositoryImpl()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getMyGifts(categoryId: Int?, brandId: Int?, page: Int, pageSize: Int?) -> AnyPublisher<PaginationResponse<[MyGift]>, Error> {
        api.request(
            target: GiftsTargets.GetMyGifts(
                categoryId: categoryId,
                brandId: brandId,
                page: page,
                pageSize: pageSize
            )
        )
    }

    func getGiftsInShop(categoryId: Int?, brandId: String?, query: String?, page: Int, pageSize: Int?, isFeatured: Bool?, isTodayOffer: Bool?, isRecommend: Bool?) -> AnyPublisher<PaginationResponse<[Gift]>, Error> {
        api.request(
            target: GiftsTargets.GetGiftsInShop(
                categoryId: categoryId,
                brandId: brandId,
                query: query,
                page: page,
                pageSize: pageSize,
                isFeatured: isFeatured,
                isTodayOffer: isTodayOffer,
                isRecommend: isRecommend
            )
        )
    }

    func getGiftsBrands(page: Int, pageSize: Int) -> AnyPublisher<PaginationResponse<[GiftBrand]>, Error> {
        api.request(
            target: GiftsTargets.GetGiftsBrands(
                page: page,
                pageSize: pageSize
            )
        )
    }

    func getGiftsCategories(page: Int, pageSize: Int) -> AnyPublisher<PaginationResponse<[GiftCategory]>, Error> {
        api.request(
            target: GiftsTargets.GetGiftsCategories(page: page, pageSize: pageSize)
        )
    }

    func buyGift(_ id: String) -> AnyPublisher<MyGift, Error> {
        api.request(
            target: GiftsTargets.BuyGift(giftId: id),
            atKeyPath: "data"
        )
    }
}
