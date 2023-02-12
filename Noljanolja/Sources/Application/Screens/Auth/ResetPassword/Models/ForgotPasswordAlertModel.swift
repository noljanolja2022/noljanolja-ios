//
//  ForgotPasswordAlertModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/02/2023.
//

import Foundation

enum ForgotPasswordAlertType: Identifiable {
    case success
    case error(error: Error)

    var id: Int {
        switch self {
        case .success: return 0
        case .error: return 1
        }
    }

    var title: String {
        switch self {
        case .success: return L10n.Common.Success.title
        case .error: return L10n.Common.Error.title
        }
    }

    var actionTitle: String {
        switch self {
        case .success: return L10n.Common.ok // TODO: Update
        case .error: return L10n.Common.ok
        }
    }

    var message: String {
        switch self {
        case .success: return L10n.Auth.ResetPassword.Success.description
        case let .error(error): return "Reset password failed.\nDETAIL: \(error.localizedDescription)"
        }
    }
}
