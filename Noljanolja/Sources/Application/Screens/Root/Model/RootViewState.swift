//
//  RootViewState.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//

import Foundation

// MARK: - RootViewState

final class RootViewState: ObservableObject {
    @Published var contentType = ContentType.launch
}

// MARK: RootViewState.ContentType

extension RootViewState {
    enum ContentType {
        case launch
        case auth
        case main
    }
}
