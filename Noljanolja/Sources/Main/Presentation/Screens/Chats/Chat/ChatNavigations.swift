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
    case forwardMessage(Message)
}

// MARK: - ChatFullScreenCoverType

enum ChatFullScreenCoverType: Equatable {
    case urlDetail(URL)
    case messageQuickReaction(Message, CGRect)
    case messageActionDetail(NormalMessageModel, CGRect)
}
