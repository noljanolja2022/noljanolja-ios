//
//  WalletPointView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/05/2023.
//

import SwiftUI

struct WalletPointView: View {
    let model: WalletPointModel
    let pointColor: Color
    var action: (() -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 12) {
            Text(model.title)
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)

            HStack(spacing: 4) {
                Text(model.point.formatted())
                    .foregroundColor(pointColor)
                Text("P")
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            }
            .font(.system(size: 28, weight: .bold))

            Button(
                action: {
                    action?()
                },
                label: {
                    Text(model.actionTitle.uppercased())
                        .font(.system(size: 14, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        .background(ColorAssets.primaryGreen200.swiftUIColor)
                        .cornerRadius(4)
                }
            )
            .padding(.top, 12)
            .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(12)
    }
}
