//
//  SettingItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/04/2023.
//

import SwiftUI

// MARK: - SettingItemView

struct SettingItemView<Content: View>: View {
    private let title: String
    private let content: Content
    private let action: (() -> Void)?

    init(title: String,
         @ViewBuilder content: () -> Content = { EmptyView() },
         action: (() -> Void)? = nil) {
        self.title = title
        self.content = content()
        self.action = action
    }

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        Button(
            action: {
                action?()
            },
            label: {
                buildContentView()
            }
        )
    }

    private func buildContentView() -> some View {
        HStack(spacing: 8) {
            Text(title)
                .dynamicFont(.systemFont(ofSize: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            content
        }
        .padding(.horizontal, 24)
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(10)
    }
}

// MARK: - SettingItemView_Previews

struct SettingItemView_Previews: PreviewProvider {
    static var previews: some View {
        SettingItemView(
            title: L10n.commonSetting,
            content: {}
        )
    }
}
