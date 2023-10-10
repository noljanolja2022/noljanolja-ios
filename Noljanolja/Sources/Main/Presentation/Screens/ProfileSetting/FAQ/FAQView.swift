//
//  FAQView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/05/2023.
//
//

import SwiftUI

// MARK: - FAQView

struct FAQView<ViewModel: FAQViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.videoTitle)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildMainView() -> some View {
        buildContentView()
    }

    private func buildContentView() -> some View {
        ScrollView {
            LazyVStack(spacing: 4) {
                FAQItemView(
                    title: "What is NolgoBulja?",
                    description: "NolgoBulja is an entertainment app. We provide video, livestream service. you can earn by watching and buy products in the shop by the points received after watching."
                )
                FAQItemView(
                    title: "What are Benefits?",
                    description: "NolgoBulja is an entertainment app. We provide video, livestream service. you can earn by watching and buy products in the shop by the points received after watching."
                )
                FAQItemView(
                    title: "How can I make purchase?",
                    description: "NolgoBulja is an entertainment app. We provide video, livestream service. you can earn by watching and buy products in the shop by the points received after watching."
                )
                FAQItemView(
                    title: "How can I get more points?",
                    description: "NolgoBulja is an entertainment app. We provide video, livestream service. you can earn by watching and buy products in the shop by the points received after watching."
                )

                FAQItemView(
                    title: "How to delete account?",
                    description: "NolgoBulja is an entertainment app. We provide video, livestream service. you can earn by watching and buy products in the shop by the points received after watching."
                )
            }
        }
    }
}

// MARK: - FAQView_Previews

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView(viewModel: FAQViewModel())
    }
}
