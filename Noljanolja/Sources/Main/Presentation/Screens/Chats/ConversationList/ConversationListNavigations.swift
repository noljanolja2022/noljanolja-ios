//
//  ConversationListNavigations.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//

import Foundation

// MARK: - ConversationListNavigationType

enum ConversationListNavigationType {
    case chat(Conversation)
    case contactList(ConversationType)
    case setting
}

// MARK: - ConversationListFullScreenCoverType

enum ConversationListFullScreenCoverType {
    case createConversation
}
