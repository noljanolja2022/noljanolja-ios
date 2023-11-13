//
//  Gift.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/06/2023.
//

import Foundation

struct Gift: Equatable, Decodable {
    let id: String
    let giftNo: Int
    let name: String?
    let description: String?
    let image: String?
    let endTime: Date?
    let price: Double
    let brand: GiftBrand?

    enum CodingKeys: String, CodingKey {
        case id
        case giftNo
        case name
        case description
        case image
        case endTime
        case price
        case brand
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.giftNo = try container.decode(Int.self, forKey: .giftNo)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)

        let endTimeString = try container.decodeIfPresent(String.self, forKey: .endTime)
        self.endTime = endTimeString?.date(withFormats: NetworkConfigs.Format.apiFullDateFormats)

        self.price = try container.decode(Double.self, forKey: .price)
        self.brand = try container.decodeIfPresent(GiftBrand.self, forKey: .brand)
    }
}
