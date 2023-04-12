//
//  User.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/03/2023.
//

import Foundation

// MARK: - GenderType

enum GenderType: String, Codable, CaseIterable {
    case male = "MALE"
    case female = "FEMALE"
    case other = "OTHER"
    case unknown = "UNKOWN"
}

// MARK: - UserPreferences

struct UserPreferences: Equatable, Codable {
    let collectAndUsePersonalInfo: Bool?
}

// MARK: - User

struct User: Equatable, Codable {
    let id: String
    let name: String?
    let avatar: String?
    let pushToken: String?
    let phone: String?
    let email: String?
    let isEmailVerified: Bool
    let dob: Date?
    let gender: GenderType?
    let preferences: UserPreferences?
    let createdAt: Date
    let updatedAt: Date

    init(id: String,
         name: String?,
         avatar: String?,
         pushToken: String?,
         phone: String?,
         email: String?,
         isEmailVerified: Bool,
         dob: Date?,
         gender: GenderType?,
         preferences: UserPreferences?,
         createdAt: Date,
         updatedAt: Date) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.pushToken = pushToken
        self.phone = phone
        self.email = email
        self.isEmailVerified = isEmailVerified
        self.dob = dob
        self.gender = gender
        self.preferences = preferences
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.pushToken = try container.decodeIfPresent(String.self, forKey: .pushToken)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.isEmailVerified = try container.decodeIfPresent(Bool.self, forKey: .isEmailVerified) ?? false

        let dobString = try container.decodeIfPresent(String.self, forKey: .dob)
        self.dob = dobString.flatMap { $0.date(withFormat: NetworkConfigs.Format.apiDateFormat) }
        
        self.gender = try container.decodeIfPresent(GenderType.self, forKey: .gender)
        self.preferences = try container.decodeIfPresent(UserPreferences.self, forKey: .preferences)

        if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt),
           let createdAt = createdAtString.date(withFormats: NetworkConfigs.Format.apiFullDateFormats) {
            self.createdAt = createdAt
        } else {
            throw NetworkError.mapping("\(String(describing: Swift.type(of: self))) at key createdAt")
        }

        if let updatedAtString = try container.decodeIfPresent(String.self, forKey: .updatedAt),
           let updatedAt = updatedAtString.date(withFormats: NetworkConfigs.Format.apiFullDateFormats) {
            self.updatedAt = updatedAt
        } else {
            throw NetworkError.mapping("\(String(describing: Swift.type(of: self))) at key updatedAt")
        }
    }
}

extension User {
    var isSettedUp: Bool {
        !(name ?? "").isEmpty
    }

    func getDisplayName(currentUser: User) -> String? {
        name // id == currentUser.id ? "You" : name
    }
}

extension [User] {
    func sorted(currentUser: User) -> Self {
        sorted { lhs, rhs in
            if lhs.id == currentUser.id {
                return true
            } else if rhs.id == currentUser.id {
                return false
            } else if (lhs.name?.trimmed ?? "").isEmpty {
                return false
            } else if (rhs.name?.trimmed ?? "").isEmpty {
                return true
            } else {
                return lhs.name?.lowercased() ?? "" < rhs.name?.lowercased() ?? ""
            }
        }
    }

    func getDisplayName(currentUser: User) -> String? {
        let displayNames = sorted(currentUser: currentUser)
            .compactMap {
                $0.getDisplayName(currentUser: currentUser)
            }
            .filter { !$0.isEmpty }

        switch count {
        case 0:
            return "Nobody"
        case 1:
            return displayNames.first
        case 2:
            return displayNames.joined(separator: " and ")
        default:
            return [displayNames.first, "\(count - 1) others"]
                .compactMap { $0 }
                .joined(separator: " and ")
        }
    }
}
