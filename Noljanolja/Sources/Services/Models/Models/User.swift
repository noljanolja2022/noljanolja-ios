//
//  User.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/03/2023.
//

import Foundation

struct User: Equatable, Codable {
    let id: String
    let name: String?
    let avatar: String?
    let phone: String?
    let email: String?
    let isEmailVerified: Bool
    let pushToken: String?
    let dob: String?
    let gender: String?

    var isSetup: Bool {
        !(name ?? "").isEmpty
    }

    enum CodingKeys: CodingKey {
        case id
        case name
        case avatar
        case phone
        case email
        case isEmailVerified
        case pushToken
        case dob
        case gender
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.isEmailVerified = try container.decodeIfPresent(Bool.self, forKey: .isEmailVerified) ?? false
        self.pushToken = try container.decodeIfPresent(String.self, forKey: .pushToken)
        self.dob = try container.decodeIfPresent(String.self, forKey: .dob)
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
    }

    init(id: String,
         name: String?,
         avatar: String?,
         phone: String?,
         email: String?,
         isEmailVerified: Bool,
         pushToken: String?,
         dob: String?,
         gender: String?) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.phone = phone
        self.email = email
        self.isEmailVerified = isEmailVerified
        self.pushToken = pushToken
        self.dob = dob
        self.gender = gender
    }
}
