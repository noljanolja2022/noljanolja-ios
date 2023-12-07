//
//  ItemProfileView.swift
//  Noljanolja
//
//  Created by duydinhv on 05/12/2023.
//

import SwiftUI

struct ItemProfileView: View {
    let title: String
    let content: String
    var ranking: LoyaltyTierModelType?

    var body: some View {
        HStack {
            Text(title)
                .dynamicFont(.systemFont(ofSize: 12, weight: .bold))
                .frame(width: UIScreen.mainWidth * 0.25, alignment: .leading)
            if let ranking {
                WalletMemberTierView(model: ranking)
            } else {
                Text(content)
                    .dynamicFont(.systemFont(ofSize: 12))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
    }
}
