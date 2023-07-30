//
//  WalletMemberTierView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/05/2023.
//

import SwiftUI

struct WalletMemberTierView: View {
    let model: LoyaltyTierModelType?

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        if let model {
            HStack(spacing: 8) {
                ImageAssets.icRank.swiftUIImage
                    .resizable()
                    .frame(width: 20, height: 15)
                    .scaledToFit()
                    .foregroundColor(Color(model.iconColor))

                Text(model.text)
                    .dynamicFont(.systemFont(ofSize: 11, weight: .bold))
                    .foregroundColor(Color(model.textColor))
            }
            .frame(height: 28)
            .padding(.horizontal, 12)
            .background(Color(model.backgroundColor))
            .cornerRadius(14)
        }
    }
}
