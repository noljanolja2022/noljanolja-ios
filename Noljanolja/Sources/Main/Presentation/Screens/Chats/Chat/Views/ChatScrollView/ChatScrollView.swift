//
//  ChatScrollView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/05/2023.
//

import SwiftUI

// MARK: - ScrollViewOffsetPreferenceKey

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat.zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

// MARK: - ChatScrollView

// A ScrollView wrapper that tracks scroll offset changes.
struct ChatScrollView<Content>: View where Content: View {
    @Namespace var scrollSpace

    @Binding var scrollOffset: CGFloat
    private let content: Content

    init(scrollOffset: Binding<CGFloat>,
         @ViewBuilder content: @escaping () -> Content) {
        _scrollOffset = scrollOffset
        self.content = content()
    }

    var body: some View {
        ScrollView {
            content
                .background(
                    GeometryReader { proxy in
                        let offset = -proxy.frame(in: .named(scrollSpace)).minY
                        Color.clear
                            .preference(
                                key: ScrollViewOffsetPreferenceKey.self,
                                value: offset
                            )
                    }
                )
        }
        .coordinateSpace(name: scrollSpace)
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
    }
}
