//
//  View+Progress.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//

import SwiftUI

extension View {
    func progress(active: Binding<Bool>) -> some View {
        modifier(ProgressViewModifier(active: active))
    }
}

// MARK: - ProgressViewModifier

struct ProgressViewModifier: ViewModifier {
    @Binding var active: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            if active {
                FullScreenProgressView()
            }
        }
    }
}
