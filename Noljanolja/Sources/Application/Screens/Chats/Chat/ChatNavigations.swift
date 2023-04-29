//
//  Chatnavigations.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//

import Foundation

// MARK: - ChatNavigationType

enum ChatNavigationType: Equatable {
    case chatSetting(Conversation)
}

// MARK: - ChatFullScreenCoverType

enum ChatFullScreenCoverType: Equatable {
    case openUrl(URL)
    case openImageDetail(URL)
}
