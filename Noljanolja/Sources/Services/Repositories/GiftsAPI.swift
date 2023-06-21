//
//  GiftsAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/06/2023.
//

import Combine
import Foundation
import Moya

// MARK: - GiftsAPITargets

private enum GiftsAPITargets {
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
                "pageSize": pageSize
            ]
            return parameters.compactMapValues { $0 }
        }
    }

    struct GetGiftsInShop: BaseAuthTargetType {
        var path: String { "v1/gifts" }
        let method: Moya.Method = .get
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        let categoryId: Int?
        let brandId: Int?
        let name: String?
        let page: Int
        let pageSize: Int?

        var parameters: [String: Any] {
            let parameters: [String: Any?] = [
                "categoryId": categoryId,
                "brandId": brandId,
                "name": name,
                "page": page,
                "pageSize": pageSize
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
                "pageSize": pageSize
            ]
            return parameters.compactMapValues { $0 }
        }
    }

    struct GetGiftsCategories: BaseAuthTargetType {
        var path: String { "v1/gifts/categories" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }
    }

    struct BuyCoupon: BaseAuthTargetType {
        var path: String { "v1/gifts/\(couponId)/buy" }
        let method: Moya.Method = .post
        var task: Task { .requestPlain }

        let couponId: Int
    }
}

// MARK: - GiftsAPIType

protocol GiftsAPIType {
    func getMyGifts(categoryId: Int?, brandId: Int?, page: Int, pageSize: Int?) -> AnyPublisher<PaginationResponse<[MyCoupon]>, Error>
    func getGiftsInShop(categoryId: Int?, brandId: Int?, name: String?, page: Int, pageSize: Int?) -> AnyPublisher<PaginationResponse<[Coupon]>, Error>
    func getGiftsBrands(page: Int, pageSize: Int) -> AnyPublisher<[CouponBrand], Error>
    func getGiftsCategories() -> AnyPublisher<[CouponCategory], Error>
    func buyCoupon(_ id: Int) -> AnyPublisher<MyCoupon, Error>
}

extension GiftsAPIType {
    func getMyGifts(categoryId: Int? = nil,
                    brandId: Int? = nil,
                    page: Int,
                    pageSize: Int? = nil) -> AnyPublisher<PaginationResponse<[MyCoupon]>, Error> {
        getMyGifts(categoryId: categoryId, brandId: brandId, page: page, pageSize: pageSize)
    }

    func getGiftsInShop(categoryId: Int? = nil,
                        brandId: Int? = nil,
                        name: String? = nil,
                        page: Int,
                        pageSize: Int? = nil) -> AnyPublisher<PaginationResponse<[Coupon]>, Error> {
        getGiftsInShop(categoryId: categoryId, brandId: brandId, name: name, page: page, pageSize: pageSize)
    }
}

// MARK: - GiftsAPI

final class GiftsAPI: GiftsAPIType {
    static let `default` = GiftsAPI()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getMyGifts(categoryId: Int?, brandId: Int?, page: Int, pageSize: Int?) -> AnyPublisher<PaginationResponse<[MyCoupon]>, Error> {
        api.request(
            target: GiftsAPITargets.GetMyGifts(
                categoryId: categoryId,
                brandId: brandId,
                page: page,
                pageSize: pageSize
            )
        )
    }

    func getGiftsInShop(categoryId: Int?, brandId: Int?, name: String?, page: Int, pageSize: Int?) -> AnyPublisher<PaginationResponse<[Coupon]>, Error> {
        api.request(
            target: GiftsAPITargets.GetGiftsInShop(
                categoryId: categoryId,
                brandId: brandId,
                name: name,
                page: page,
                pageSize: pageSize
            )
        )
    }

    func getGiftsBrands(page: Int, pageSize: Int) -> AnyPublisher<[CouponBrand], Error> {
        api.request(
            target: GiftsAPITargets.GetGiftsBrands(
                page: page,
                pageSize: pageSize
            ),
            atKeyPath: "data"
        )
    }

    func getGiftsCategories() -> AnyPublisher<[CouponCategory], Error> {
        api.request(
            target: GiftsAPITargets.GetGiftsCategories(),
            atKeyPath: "data"
        )
    }

    func buyCoupon(_ id: Int) -> AnyPublisher<MyCoupon, Error> {
        api.request(
            target: GiftsAPITargets.BuyCoupon(couponId: id),
            atKeyPath: "data"
        )
    }
}
