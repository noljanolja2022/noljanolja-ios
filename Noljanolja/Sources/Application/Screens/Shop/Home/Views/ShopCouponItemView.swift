//
//  ShopCouponItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/06/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - ShopCouponItemView

struct ShopCouponItemView: View {
    var model: Coupon

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContenView()
    }

    private func buildContenView() -> some View {
        VStack(spacing: 4) {
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
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(12)
                .clipped()
            }
            .aspectRatio(1, contentMode: .fill)

            Text(model.brand?.name ?? "")
                .font(.system(size: 12, weight: .medium))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            Text(model.name ?? "")
                .font(.system(size: 14, weight: .medium))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            HStack(spacing: 4) {
                Text(String(model.price))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(ColorAssets.secondaryYellow300.swiftUIColor)
                Text("Points")
                    .font(.system(size: 24))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(12)
    }
}
