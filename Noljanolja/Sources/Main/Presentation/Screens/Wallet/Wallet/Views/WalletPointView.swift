//
//  WalletPointView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/05/2023.
//

import SwiftUI

// MARK: - WalletPointViewDataModel

struct WalletPointViewDataModel {
    let title: String
    let titleColorName: String
    let point: Int
    let pointColorName: String
    let unitColorName: String
    let actionTitle: String
    let backgroundImageName: String
}

// MARK: - WalletPointView

struct WalletPointView: View {
    let model: WalletPointViewDataModel
    var action: (() -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 12) {
            Text(model.title)
                .multilineTextAlignment(.center)
                .dynamicFont(.systemFont(ofSize: 16, weight: .medium))
                .foregroundColor(Color(model.titleColorName))

            HStack(spacing: 4) {
                Text(model.point.formatted())
                    .foregroundColor(Color(model.pointColorName))
                Text("P")
                    .foregroundColor(Color(model.unitColorName))
            }
            .dynamicFont(.systemFont(ofSize: 28, weight: .bold))

//            Button(
//                action: {
//                    action?()
//                },
//                label: {
//                    Text(model.actionTitle.uppercased())
//                        .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 12)
//                        .padding(.horizontal, 8)
//                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
//                        .background(ColorAssets.primaryGreen200.swiftUIColor)
//                        .cornerRadius(4)
//                }
//            )
//            .padding(.top, 12)
//            .shadow(
//                color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.2),
//                radius: 8,
//                x: 0,
//                y: 4
//            )
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fill)
        .background {
            Image(model.backgroundImageName)
                .resizable()
                .scaledToFill()
        }
        .cornerRadius(12)
        .onTapGesture {
            action?()
        }
    }
}
