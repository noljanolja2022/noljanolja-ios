//
//  MyGiftItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/06/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - MyGiftItemView

struct MyGiftItemView: View {
    @EnvironmentObject var themeManager: AppThemeManager

    var model: MyGift
    var selectAction: (() -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContenView()
    }

    private func buildContenView() -> some View {
        HStack(spacing: 16) {
            buildImageView()
            buildInfoView()
        }
        .padding(6)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(8)
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
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
            .cornerRadius(4)
            .clipped()
        }
        .frame(width: 100, height: 100)
    }

    private func buildInfoView() -> some View {
        VStack {
            Text(model.brand?.name ?? "")
                .dynamicFont(.systemFont(ofSize: 11, weight: .regular))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            Text(model.name ?? "")
                .dynamicFont(.systemFont(ofSize: 12, weight: .regular))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            HStack {
                Button {
                    selectAction?()
                } label: {
                    Text(L10n.walletExchangeMoney.uppercased())
                        .dynamicFont(.systemFont(ofSize: 14, weight: .regular))
                        .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                        .padding(.horizontal, 13)
                }
                .frame(height: 30)
                .background(themeManager.theme.primary200)
                .cornerRadius(5)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}
