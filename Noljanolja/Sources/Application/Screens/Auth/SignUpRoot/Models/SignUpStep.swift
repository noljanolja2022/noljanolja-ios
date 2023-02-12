//
//  SignUpStep.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//

import Foundation

enum SignUpStep: CaseIterable {
    case first
    case second

    var index: CGFloat {
        switch self {
        case .first: return 1
        case .second: return 2
        }
    }

    var title: String {
        switch self {
        case .first: return L10n.Auth.SignUp.Step1.title
        case .second: return L10n.Auth.SignUp.Step2.title
        }
    }

    var description: String {
        switch self {
        case .first: return L10n.Auth.SignUp.Step1.description
        case .second: return L10n.Auth.SignUp.Step2.description
        }
    }
}
