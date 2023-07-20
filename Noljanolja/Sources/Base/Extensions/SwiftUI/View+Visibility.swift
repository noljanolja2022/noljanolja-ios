//
//  View+Visibility.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/05/2023.
//

import Swift
import SwiftUI

// MARK: - VisibilityType

enum VisibilityType {
    case visible
    case invisible
    case gone
}

// MARK: - _VisibilityModifier

/// A modifier that controls a view's visibility.
struct _VisibilityModifier: ViewModifier {
    let visibilityType: VisibilityType

    init(visibilityType: VisibilityType) {
        self.visibilityType = visibilityType
    }

    func body(content: Content) -> some View {
        switch visibilityType {
        case .visible:
            content
        case .invisible:
            content.hidden()
        case .gone:
            EmptyView()
        }
    }
}

// MARK: - Helpers

extension View {
    /// Sets a view's visibility.
    ///
    /// The view still retains its frame.
    func visible(_ visibilityType: VisibilityType = .visible) -> some View {
        modifier(_VisibilityModifier(visibilityType: visibilityType))
    }

    /// Sets a view's visibility.
    ///
    /// The view still retains its frame.
    func visible(_ visibilityType: VisibilityType = .visible, animation: Animation?) -> some View {
        modifier(_VisibilityModifier(visibilityType: visibilityType))
            .animation(animation, value: visibilityType)
    }
}
