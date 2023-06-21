//
//  MyCoupon.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/06/2023.
//

import Foundation

struct MyCoupon: Equatable, Decodable {
    let id: Int
    let name: String?
    let description: String?
    let image: String?
    let code: String
    let category: CouponCategory?
    let brand: CouponBrand?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case image
        case code
        case category
        case brand
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.code = try container.decode(String.self, forKey: .code)
        self.category = try container.decodeIfPresent(CouponCategory.self, forKey: .category)
        self.brand = try container.decodeIfPresent(CouponBrand.self, forKey: .brand)
    }
}
