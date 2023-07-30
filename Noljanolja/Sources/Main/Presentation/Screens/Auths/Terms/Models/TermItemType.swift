//
//  TermItemType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//

import Foundation

// MARK: - TermSectionType

enum TermSectionType: Int, CaseIterable {
    case compulsory
    case optional

    var title: String {
        switch self {
        case .compulsory: return L10n.tosCompulsory
        case .optional: return L10n.tosOptional
        }
    }
}

// MARK: Identifiable

extension TermSectionType: Identifiable {
    var id: Int { rawValue }
}

// MARK: - TermItemType

enum TermItemType: Int, CaseIterable {
    case termOfService
    case minAge
    case personalInfo
    case marketingInfo

    var title: String {
        switch self {
        case .termOfService: return L10n.tosCompulsoryItemTitle1
        case .minAge: return L10n.tosCompulsoryItemTitle2
        case .personalInfo: return L10n.tosCompulsoryItemTitle3
        case .marketingInfo: return L10n.tosOptionalItemTitle1
        }
    }

    var sectionType: TermSectionType {
        switch self {
        case .termOfService, .minAge, .personalInfo:
            return .compulsory
        case .marketingInfo:
            return .optional
        }
    }
}

// MARK: Identifiable

extension TermItemType: Identifiable {
    var id: Int { rawValue }
}