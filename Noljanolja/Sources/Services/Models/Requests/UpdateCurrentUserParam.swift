//
//  UpdateCurrentUserParam.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import Foundation

// MARK: - UpdateCurrentUserPreferencesParam

struct UpdateCurrentUserPreferencesParam: Codable {
    let collectAndUsePersonalInfo: Bool

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(collectAndUsePersonalInfo, forKey: .collectAndUsePersonalInfo)
    }
}

// MARK: - UpdateCurrentUserParam

struct UpdateCurrentUserParam: Codable {
    let name: String
    let email: String
    let gender: String
    let dob: String
    let preferences: UpdateCurrentUserPreferencesParam

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(gender, forKey: .gender)
        try container.encodeIfPresent(dob, forKey: .dob)
        try container.encodeIfPresent(preferences, forKey: .preferences)
    }
}
