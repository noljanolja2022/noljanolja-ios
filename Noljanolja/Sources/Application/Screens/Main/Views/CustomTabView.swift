//
//  TabBarView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/05/2023.
//

import SwiftUI

// MARK: - CustomTabView

struct CustomTabView<SelectionValue, Content, TabItem>: View where SelectionValue: Hashable, Content: View, TabItem: View {
    private let selection: Binding<SelectionValue>?
    private let content: Content
    private let tabItem: TabItem

    init(selection: Binding<SelectionValue>? = nil,
         @ViewBuilder content: () -> Content,
         @ViewBuilder tabItem: () -> TabItem) {
        self.selection = selection
        self.content = content()
        self.tabItem = tabItem()
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: selection) {
                content
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            Divider()
                .frame(height: 1)
                .overlay(Color.gray.opacity(0.1))

            HStack(spacing: 0) {
                tabItem
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

extension CustomTabView where SelectionValue == Int {
    init(@ViewBuilder content: () -> Content,
         @ViewBuilder tabItem: () -> TabItem) {
        self.init(
            selection: nil,
            content: content,
            tabItem: tabItem
        )
    }
}

// MARK: - CustomTabView_Previews

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(
            content: {
                TabItemView(
                    imageName: ImageAssets.icChat.name,
                    title: "Chat"
                )
                TabItemView(
                    imageName: ImageAssets.icWallet.name,
                    title: "Wallet"
                )
            },
            tabItem: {}
        )
    }
}
