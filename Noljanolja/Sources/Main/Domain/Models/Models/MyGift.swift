//
//  MyGift.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/06/2023.
//

import Foundation

struct MyGift: Equatable, Decodable {
    let id: String
    let giftId: String
    let name: String?
    let description: String?
    let image: String?
    let qrCode: String
    let brand: GiftBrand?
    let log: String?

    enum CodingKeys: String, CodingKey {
        case id
        case giftId
        case name
        case description
        case image
        case qrCode
        case brand
        case log
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.giftId = try container.decode(String.self, forKey: .giftId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.qrCode = try container.decode(String.self, forKey: .qrCode)
        self.brand = try container.decodeIfPresent(GiftBrand.self, forKey: .brand)
        self.log = try container.decodeIfPresent(String.self, forKey: .log)
    }
}
