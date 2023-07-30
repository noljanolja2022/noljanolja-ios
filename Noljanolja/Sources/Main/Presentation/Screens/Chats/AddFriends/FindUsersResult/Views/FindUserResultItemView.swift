//
//  FindUserResultItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/06/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - FindUserResultItemView

struct FindUserResultItemView: View {
    let model: User
    let chatAction: (() -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(spacing: 12) {
            WebImage(
                url: URL(string: model.avatar),
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(width: 40 * 3, height: 40 * 3),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .indicator(.activity)
            .scaledToFill()
            .frame(width: 40, height: 40)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
            .cornerRadius(14)

            VStack(spacing: 4) {
                Text(model.name ?? "")
                    .dynamicFont(.systemFont(ofSize: 16, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                Text(model.phone ?? "")
                    .dynamicFont(.systemFont(ofSize: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            }

            Button(
                action: {
                    chatAction?()
                },
                label: {
                    HStack(spacing: 4) {
                        ImageAssets.icChat.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text(L10n.addFriendsChatNow)
                            .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .foregroundColor(ColorAssets.neutralRawLight.swiftUIColor)
                    .background(ColorAssets.primaryGreen200.swiftUIColor)
                    .cornerRadius(8)
                }
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
