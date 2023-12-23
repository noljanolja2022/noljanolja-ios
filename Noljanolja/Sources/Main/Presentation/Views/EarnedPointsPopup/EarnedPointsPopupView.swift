//
//  EarnedPointsPopupView.swift
//  Noljanolja
//
//  Created by duydinhv on 20/12/2023.
//

import SwiftUI

// MARK: - EarnedPointsPopupView

struct EarnedPointsPopupView: View {
    let point = 100
    
    var body: some View {
        BottomSheet {
            VStack {
                ImageAssets.icEarnedPoints.swiftUIImage
                    .scaledToFit()
                    .height(38)
                    .padding(.bottom, 10)

                VStack(spacing: 12) {
                    Text(L10n.transactionHistoryPoint(point))
                        .dynamicFont(.systemFont(ofSize: 22, weight: .medium))
                    Text(L10n.referralReceivePoint(point))
                        .multilineTextAlignment(.center)
                        .dynamicFont(.systemFont(ofSize: 14))
                        .padding(.horizontal, 30)
                }
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .padding(.bottom, 50)

                Button(L10n.commonOk.uppercased()) {}
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal, 10)
            }
            .padding(.top, 42)
        }
    }
}

// MARK: - EarnedPointsPopupView_Previews

struct EarnedPointsPopupView_Previews: PreviewProvider {
    static var previews: some View {
        EarnedPointsPopupView()
    }
}
