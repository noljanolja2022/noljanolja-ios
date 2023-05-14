//
//  WalletUserInfoView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/05/2023.
//

import SDWebImageSwiftUI
import SwiftUI

struct WalletUserInfoView: View {
    let model: WalletUserInfoModel
    var settingAction: (() -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(spacing: 24) {
            WebImage(
                url: URL(string: model.avatar),
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(width: 64 * 3, height: 64 * 3),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .indicator(.activity)
            .scaledToFill()
            .frame(width: 64, height: 64)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
            .cornerRadius(32)

            VStack(alignment: .leading, spacing: 8) {
                Text(model.name ?? "")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

                WalletMemberTierView(model: model.tierModelType)

                Text("Overall Point Ranking: 12,345")
                    .font(.system(size: 10, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }

            VStack(spacing: 0) {
                Button(
                    action: {
                        settingAction?()
                    },
                    label: {
                        ImageAssets.icSettingFill.swiftUIImage
                            .frame(width: 24, height: 24)
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    }
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius([.bottomLeading, .bottomTrailing], 24)
    }
}
