//
//  TransactionHistoryHeaderView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/05/2023.
//

import SwiftUI

struct TransactionHistoryHeaderView: View {
    let model: TransactionHistoryHeaderModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(spacing: 12) {
            Text(model.displayDateTime)
                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)

            HStack(spacing: 0) {
                Text(L10n.walletHistoryDashboard)
                    .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                    .foregroundColor(ColorAssets.systemBlue.swiftUIColor)

                ImageAssets.icArrowRight.swiftUIImage
                    .resizable()
                    .padding(4)
                    .frame(width: 24, height: 24)
                    .foregroundColor(ColorAssets.systemBlue.swiftUIColor)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(ColorAssets.lightBlue.swiftUIColor)
    }
}
