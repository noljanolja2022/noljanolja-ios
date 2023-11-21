//
//  ShopGiftCollectionItemView.swift
//  Noljanolja
//
//  Created by Duy Dinh on 21/11/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - ShopGiftItemView

struct ShopGiftCollectionItemView: View {
    var model: Gift

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContenView()
    }

    private func buildContenView() -> some View {
        VStack {
            VStack(spacing: 8) {
                buildImageView()
                buildInfoView()
            }
            .background(ColorAssets.neutralLight.swiftUIColor)
            .cornerRadius(10)
            .padding(.bottom, 16)
        }
        .shadow(
            color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.2),
            radius: 8,
            x: 0,
            y: 4
        )
    }

    private func buildImageView() -> some View {
        GeometryReader { geometry in
            WebImage(
                url: URL(string: model.image),
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(
                            width: geometry.size.width * 3,
                            height: geometry.size.height * 3
                        ),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .indicator(.activity)
            .clipped()
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
        }
    }

    private func buildInfoView() -> some View {
        VStack(alignment: .leading) {
            Text(model.brand?.name ?? "")
                .dynamicFont(.systemFont(ofSize: 11, weight: .medium))
                .lineLimit(2)
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            Text(model.name ?? "")
                .dynamicFont(.systemFont(ofSize: 12, weight: .medium))
                .lineLimit(2)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            HStack(spacing: 4) {
                Text(String(model.price))
                    .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                Text("Cash")
                    .dynamicFont(.systemFont(ofSize: 14))
                    .frame(height: 24)
                    .padding(.horizontal, 8)
                    .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                    .background(ColorAssets.secondaryYellow400.swiftUIColor)
                    .cornerRadius(12)
            }
        }
        .padding(.leading, 8)
        .padding(.bottom, 16)
    }
}
