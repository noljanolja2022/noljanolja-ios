//
//  Chatnavigations.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//

import Foundation
import SwiftUI

// MARK: - ChatNavigationType

enum ChatNavigationType: Equatable {
    case chatSetting(Conversation)
    case openImages(Message)
}

// MARK: - ChatFullScreenCoverType

enum ChatFullScreenCoverType: Equatable {
    case openUrl(URL)
    case reaction(CGRect, Message)

    var isAnimationsEnabled: Bool {
        switch self {
        case .openUrl: return true
        case .reaction: return false
        }
    }
}
