//
//  SwiftUIView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/04/2023.
//

import SwiftUI

// MARK: - NavigationBarView

struct NavigationBarView<LeadingView: View, CenterView: View, TrailingView: View>: View {
    private let leadingView: LeadingView
    private let centerView: CenterView
    private let trailingView: TrailingView
    private let isDividerHidden: Bool

    public init(@ViewBuilder leadingView: () -> LeadingView = { Spacer() },
                @ViewBuilder centerView: () -> CenterView = { Spacer() },
                @ViewBuilder trailingView: () -> TrailingView = { Spacer() },
                isDividerHidden: Bool = false) {
        self.leadingView = leadingView()
        self.centerView = centerView()
        self.trailingView = trailingView()
        self.isDividerHidden = isDividerHidden
    }

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                leadingView
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                centerView
                trailingView
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 4)

            Divider()
                .frame(height: 1)
                .overlay(Color.gray.opacity(0.1))
                .hidden(isDividerHidden)
        }
    }
}
