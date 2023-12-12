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
        VStack(spacing: 12) {
            Text(model.title)
                .multilineTextAlignment(.center)
                .dynamicFont(.systemFont(ofSize: 16, weight: .medium))
                .foregroundColor(Color(model.titleColorName))

            HStack(spacing: 4) {
                Text(model.point.formatted())
                    .foregroundColor(Color(model.pointColorName))
                Text(model.type)
                    .foregroundColor(Color(model.unitColorName))
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
        .onTapGesture {
            action?()
        }
    }
}
