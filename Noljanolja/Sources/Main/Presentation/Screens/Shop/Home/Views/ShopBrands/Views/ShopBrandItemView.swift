//
//  ShopBrandItemView.swift
//  Noljanolja
//
//  Created by Duy Đinh Văn on 29/11/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - ShopGiftItemView

struct ShopBrandItemView: View {
    var model: GiftBrand

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContenView()
    }

    private func buildContenView() -> some View {
        VStack(spacing: 5) {
            buildImageView()
            Text(model.name ?? "")
                .dynamicFont(.systemFont(ofSize: 12, weight: .regular))
                .lineLimit(2)
                .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
        }
        .background(ColorAssets.secondaryYellow300.swiftUIColor)
        .padding(.bottom, 9)
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
            .cornerRadius(5)
        }
        .frame(width: 64 * ratioW, height: 64 * ratioH)
    }
}
