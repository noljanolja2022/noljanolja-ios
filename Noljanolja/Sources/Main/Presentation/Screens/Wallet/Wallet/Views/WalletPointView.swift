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
    let titleColorName: Color
    let point: Int
    let pointColorName: Color
    let unitColorName: Color
    let actionTitle: String
    var backgroundImageName: String?
    let type: String
}

// MARK: - WalletPointView

struct WalletPointView: View {
    let model: WalletPointViewDataModel
    var action: (() -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(model.title)
                .multilineTextAlignment(.leading)
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                .foregroundColor(model.titleColorName)

            HStack(spacing: 8) {
                ImageAssets.icPoint.swiftUIImage
                    .resizable()
                    .size(30)
                Text(model.point.formatted())
                    .foregroundColor(model.pointColorName)
//                Text(model.type)
//                    .foregroundColor(Color(model.unitColorName))
            }
            .dynamicFont(.systemFont(ofSize: 28, weight: .bold))
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fill)
        .background {
            if let backgroundImageName = model.backgroundImageName {
                Image(backgroundImageName)
                    .resizable()
                    .scaledToFill()
            } else {
                ColorAssets.neutralLight.swiftUIColor
            }
        }
        .cornerRadius(12)
        .shadow(
            color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.25),
            radius: 11,
            x: 0,
            y: 4
        )
        .onTapGesture {
            action?()
        }
    }
}
