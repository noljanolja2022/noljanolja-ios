//
//  FAQItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/05/2023.
//

import SwiftUI

// MARK: - FAQItemView

struct FAQItemView: View {
    let title: String
    let description: String

    @State private var isDescriptionHidden = true

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 0) {
            buildContentView()

            Divider()
                .frame(height: 1)
                .overlay(ColorAssets.neutralLightGrey.swiftUIColor)
                .hidden(!isDescriptionHidden)
        }
        .padding(.horizontal, 16)
        .background(isDescriptionHidden ? .clear : ColorAssets.secondaryYellow50.swiftUIColor)
    }

    private func buildContentView() -> some View {
        Button(
            action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isDescriptionHidden = !isDescriptionHidden
                }
            },
            label: {
                VStack(spacing: 16) {
                    buildTitleView()
                    buildDescriptionView()
                }
                .padding(.vertical, 20)
            }
        )
    }

    private func buildTitleView() -> some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.primaryGreen300.swiftUIColor)

            ImageAssets.icArrowRight.swiftUIImage
                .resizable()
                .padding(4)
                .frame(width: 24, height: 24)
                .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
        }
    }

    @ViewBuilder
    private func buildDescriptionView() -> some View {
        if !isDescriptionHidden {
            Text(description)
                .font(.system(size: 16))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
    }
}

// MARK: - FAQItemView_Previews

struct FAQItemView_Previews: PreviewProvider {
    static var previews: some View {
        FAQItemView(
            title: "Title", description: "Description"
        )
    }
}
