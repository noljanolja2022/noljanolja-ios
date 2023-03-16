//
//  StorableContact.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/03/2023.
//

import Foundation
import RealmSwift

// MARK: - StorableUserPreferences

final class StorableUserPreferences: Object, StorableModel {
    @Persisted var collectAndUsePersonalInfo: Bool?

    var model: UserPreferences? {
        UserPreferences(collectAndUsePersonalInfo: collectAndUsePersonalInfo)
    }

    required convenience init(_ model: UserPreferences) {
        self.init()
        self.collectAndUsePersonalInfo = model.collectAndUsePersonalInfo
    }
}

// MARK: - StorableUser

final class StorableUser: Object, StorableModel {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String?
    @Persisted var avatar: String?
    @Persisted var pushToken: String?
    @Persisted var phone: String?
    @Persisted var email: String?
    @Persisted var isEmailVerified = false
    @Persisted var dob: Date?
    @Persisted var gender: String?
    @Persisted var preferences: StorableUserPreferences?
    @Persisted var createdAt: Date?
    @Persisted var updatedAt: Date?

    var model: User? {
        User(
            id: id,
            name: name,
            avatar: avatar,
            pushToken: pushToken,
            phone: phone,
            email: email,
            isEmailVerified: isEmailVerified,
            dob: Date(),
            gender: gender.flatMap { GenderType(rawValue: $0) },
            preferences: preferences?.model,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    required convenience init(_ model: User) {
        self.init()
        self.id = model.id
        self.name = model.name
        self.avatar = model.avatar
        self.pushToken = pushToken
        self.phone = model.phone
        self.email = model.email
        self.isEmailVerified = model.isEmailVerified
        self.dob = model.dob
        self.gender = model.gender?.rawValue
        self.preferences = model.preferences.flatMap { StorableUserPreferences($0) }
        self.createdAt = model.createdAt
        self.updatedAt = model.updatedAt
    }
}
