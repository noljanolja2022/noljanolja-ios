//
//  MyCouponItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/06/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - MyCouponItemView

struct MyCouponItemView: View {
    var model: MyCoupon
    var selectAction: (() -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContenView()
    }

    private func buildContenView() -> some View {
        VStack(spacing: 6) {
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(10)
                .clipped()
            }
            .aspectRatio(1, contentMode: .fill)
            .frame(maxWidth: .infinity)
            Text(model.brand?.name ?? "")
                .dynamicFont(.systemFont(ofSize: 12))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            Text(model.name ?? "")
                .dynamicFont(.systemFont(ofSize: 11))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            Button(
                L10n.walletExchangeMoney.uppercased(),
                action: {
                    selectAction?()
                }
            )
            .buttonStyle(MyCouponButtonStyle())
            .dynamicFont(.systemFont(ofSize: 12, weight: .medium))
            .frame(height: 30)
            .cornerRadius(4)
        }
        .padding(6)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(12)
    }
}
