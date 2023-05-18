//
//  LoyaltyTierModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/05/2023.
//

import Foundation

enum LoyaltyTierModelType: Equatable {
    case bronze
    case silver
    case gold
    case diamond

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
        case .bronze: return ColorAssets.neutralGrey.name
        case .silver: return ColorAssets.neutralGrey.name
        case .gold: return ColorAssets.secondaryYellow200.name
        case .diamond: return ColorAssets.secondaryYellow400.name
        }
    }

    var text: String {
        switch self {
        case .bronze: return "General Membership"
        case .silver: return "General Membership"
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
