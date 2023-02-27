//
//  ViewState.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//

import Foundation

// MARK: - ViewState

enum ViewState<Content, Failure> where Failure: Error {
    case content(Content)
    case error(Failure)
    case loading
}

extension ViewState {
    var isContent: Bool {
        switch self {
        case .content: return true
        case .error, .loading: return false
        }
    }
}
