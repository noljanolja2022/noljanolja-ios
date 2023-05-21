//
//  LoyaltyTierModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/05/2023.
//

import Foundation

enum LoyaltyTierModelType: Int, Equatable {
    case bronze = 0
    case silver = 1
    case gold = 2
    case diamond = 3

    init?(tier: LoyaltyTierType?) {
        guard let tier else { return nil }
        switch tier {
        case .bronze: self = .bronze
        case .silver: self = .silver
        case .gold: self = .gold
        case .diamond: self = .diamond
        case .unknown: return nil
        }
    }

    var iconColor: String {
        switch self {
        case .bronze: return ColorAssets.systemBrown.name
        case .silver: return ColorAssets.neutralGrey.name
        case .gold: return ColorAssets.secondaryYellow200.name
        case .diamond: return ColorAssets.secondaryYellow400.name
        }
    }

    var text: String {
        switch self {
        case .bronze: return "Bronze Membership"
        case .silver: return "Silver Membership"
        case .gold: return "Gold Membership"
        case .diamond: return "Premium Membership"
        }
    }

    var textColor: String {
        switch self {
        case .bronze: return ColorAssets.neutralDarkGrey.name
        case .silver: return ColorAssets.neutralDarkGrey.name
        case .gold: return ColorAssets.neutralLight.name
        case .diamond: return ColorAssets.neutralDarkGrey.name
        }
    }

    var backgroundColor: String {
        switch self {
        case .bronze: return ColorAssets.neutralLightGrey.name
        case .silver: return ColorAssets.neutralLightGrey.name
        case .gold: return ColorAssets.neutralDarkGrey.name
        case .diamond: return ColorAssets.secondaryYellow200.name
        }
    }
}
