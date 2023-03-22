//
//  TermOfServiceItemType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//

import Foundation

// MARK: - TermOfServiceSectionType

enum TermOfServiceSectionType: Int, CaseIterable {
    case compulsory
    case optional

    var title: String {
        switch self {
        case .compulsory: return "Compulsory"
        case .optional: return "Optional"
        }
    }
}

// MARK: Identifiable

extension TermOfServiceSectionType: Identifiable {
    var id: Int { rawValue }
}

// MARK: - TermOfServiceItemType

enum TermOfServiceItemType: Int, CaseIterable {
    case termOfService
    case minAge
    case personalInfo
    case marketingInfo

    var title: String {
        switch self {
        case .termOfService: return "Subscribe Terms of Service"
        case .minAge: return "I’m 14 years old or older."
        case .personalInfo: return "Collection and Use of Personal Information"
        case .marketingInfo: return "Consent to receive marketing information"
        }
    }

    var sectionType: TermOfServiceSectionType {
        switch self {
        case .termOfService, .minAge, .personalInfo:
            return .compulsory
        case .marketingInfo:
            return .optional
        }
    }
}

// MARK: Identifiable

extension TermOfServiceItemType: Identifiable {
    var id: Int { rawValue }
}
