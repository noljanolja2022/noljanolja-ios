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
    case minAge
    case termsAndConditions
    case comprehensiveTermsAndConditions
    case collectionPersonalInformation
    case collectionInformation
    case collectionProfileInformation

    var title: String {
        switch self {
        case .minAge: return "I'm 14 years old older"
        case .termsAndConditions: return "Terms and Conditions"
        case .comprehensiveTermsAndConditions: return "Comprehensive Terms and Conditions"
        case .collectionPersonalInformation: return "Collection and Use of Personal Information"
        case .collectionInformation: return "Consent to the collection  and use of information"
        case .collectionProfileInformation: return "Collection and Use of Profile Information"
        }
    }

    var sectionType: TermOfServiceSectionType {
        switch self {
        case .minAge, .termsAndConditions, .comprehensiveTermsAndConditions, .collectionPersonalInformation:
            return .compulsory
        case .collectionInformation, .collectionProfileInformation:
            return .optional
        }
    }
}

// MARK: Identifiable

extension TermOfServiceItemType: Identifiable {
    var id: Int { rawValue }
}
