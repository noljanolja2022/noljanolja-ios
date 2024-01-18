//
//  UpdateCurrentUserParam.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import Foundation

// MARK: - UpdateCurrentUserPreferencesParam

struct UpdateCurrentUserPreferencesParam: Codable {
    let collectAndUsePersonalInfo: Bool?

    init(collectAndUsePersonalInfo: Bool? = nil) {
        self.collectAndUsePersonalInfo = collectAndUsePersonalInfo
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(collectAndUsePersonalInfo, forKey: .collectAndUsePersonalInfo)
    }
}

// MARK: - UpdateCurrentUserParam

struct UpdateCurrentUserParam: Codable {
    let name: String
    let email: String?
    let phone: String
    let gender: GenderType?
    let dob: Date?
    let preferences: UpdateCurrentUserPreferencesParam?

    init(name: String,
         phone: String,
         email: String? = nil,
         avatar: String? = nil,
         gender: GenderType? = nil,
         dob: Date? = nil,
         preferences: UpdateCurrentUserPreferencesParam? = nil) {
        self.name = name
        self.phone = phone
        self.email = email
        self.gender = gender
        self.dob = dob
        self.preferences = preferences
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(gender?.rawValue, forKey: .gender)
        try container.encodeIfPresent(dob?.string(withFormat: NetworkConfigs.Format.apiDateFormat), forKey: .dob)
        try container.encodeIfPresent(preferences, forKey: .preferences)
    }
}
