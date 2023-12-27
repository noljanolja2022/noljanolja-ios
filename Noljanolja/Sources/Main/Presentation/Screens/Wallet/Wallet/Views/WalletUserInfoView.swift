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
    var tierAction: (() -> Void)?
    var settingAction: (() -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(spacing: 15) {
            WebImage(
                url: URL(string: model.avatar),
                options: .refreshCached,
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
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)

                Button(
                    action: {
                        tierAction?()
                    },
                    label: {
                        WalletMemberTierView(model: model.tierModelType)
                    }
                )

                Text(L10n.walletPointRanking(model.exchangeablePoints ?? 0))
                    .dynamicFont(.systemFont(ofSize: 10, weight: .medium))
                    .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }
}
