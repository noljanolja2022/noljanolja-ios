//
//  CheckinOverviewView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 31/07/2023.
//

import SwiftUI

// MARK: - CheckinOverviewView

struct CheckinOverviewView: View {
    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(spacing: 12) {
            buildItemView(isChecked: true, subtitle: L10n.walletToGet, title: L10n.walletBenefit.uppercased())
            buildItemView(isChecked: true, subtitle: L10n.walletCheckin, title: L10n.walletEveryDay.uppercased())
        }
    }

    private func buildItemView(isChecked: Bool, subtitle: String, title: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if isChecked {
                ImageAssets.icChecked.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(ColorAssets.secondaryYellow400.swiftUIColor)
            } else {
                Spacer()
                    .frame(width: 24, height: 24)
            }

            Text(subtitle)
                .dynamicFont(.systemFont(ofSize: 16))
                .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(title)
                .dynamicFont(.systemFont(ofSize: 28, weight: .bold))
                .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - CheckinOverviewView_Previews

struct CheckinOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        CheckinOverviewView()
    }
}
