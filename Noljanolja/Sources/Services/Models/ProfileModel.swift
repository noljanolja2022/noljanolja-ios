//
//  HomeModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation

struct ProfileModel: Decodable {
    let email: String
    let id: String
    let isEmailVerified: Bool
    let name: String
    let phone: String
    let profileImage: String
    let pushNotiEnabled: Bool
    let pushToken: String

    var isSetup: Bool {
        !name.isEmpty
    }

    enum CodingKeys: CodingKey {
        case email
        case id
        case isEmailVerified
        case name
        case phone
        case profileImage
        case pushNotiEnabled
        case pushToken
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.id = try container.decode(String.self, forKey: .id)
        self.isEmailVerified = try container.decodeIfPresent(Bool.self, forKey: .isEmailVerified) ?? false
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
        self.pushNotiEnabled = try container.decodeIfPresent(Bool.self, forKey: .pushNotiEnabled) ?? false
        self.pushToken = try container.decodeIfPresent(String.self, forKey: .pushToken) ?? ""
    }
}
