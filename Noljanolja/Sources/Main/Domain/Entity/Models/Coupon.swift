//
//  Coupon.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/06/2023.
//

import Foundation

struct Coupon: Equatable, Decodable {
    let id: Int
    let name: String?
    let description: String?
    let image: String?
    let startTime: Date?
    let endTime: Date?
    let price: Int
    let total: Int
    let remaining: Int
    let isPurchasable: Bool
    let category: CouponCategory?
    let brand: CouponBrand?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case image
        case startTime
        case endTime
        case price
        case total
        case remaining
        case isPurchasable
        case category
        case brand
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)

        let startTimeString = try container.decodeIfPresent(String.self, forKey: .startTime)
        self.startTime = startTimeString?.date(withFormats: NetworkConfigs.Format.apiFullDateFormats)

        let endTimeString = try container.decodeIfPresent(String.self, forKey: .endTime)
        self.endTime = endTimeString?.date(withFormats: NetworkConfigs.Format.apiFullDateFormats)

        self.price = try container.decode(Int.self, forKey: .price)
        self.total = try container.decode(Int.self, forKey: .total)
        self.remaining = try container.decode(Int.self, forKey: .remaining)
        self.isPurchasable = try container.decodeIfPresent(Bool.self, forKey: .isPurchasable) ?? false
        self.category = try container.decodeIfPresent(CouponCategory.self, forKey: .category)
        self.brand = try container.decodeIfPresent(CouponBrand.self, forKey: .brand)
    }
}
