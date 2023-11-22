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
        .padding(4)
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
        .frame(width: 110, height: 110)
    }
    
    private func buildInfoView() -> some View {
        VStack(spacing: 8) {
            Text(model.brand?.name ?? "")
                .dynamicFont(.systemFont(ofSize: 12, weight: .medium))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            Text(model.name ?? "")
                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            Button(
                L10n.walletExchangeMoney.uppercased(),
                action: {
                    selectAction?()
                }
            )
            .buttonStyle(MyGiftButtonStyle())
            .dynamicFont(.systemFont(ofSize: 12, weight: .medium))
            .frame(height: 30)
            .cornerRadius(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}