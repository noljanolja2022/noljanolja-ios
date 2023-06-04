//
//  WalletMyPointView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/05/2023.
//

import SwiftUI

// MARK: - WalletMyPointView

struct WalletMyPointView: View {
    let point: Int

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 16) {
            Text(L10n.walletMyPoint)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            HStack(spacing: 12) {
                ImageAssets.icPoint.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                Text(point.formatted())
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(ColorAssets.secondaryYellow400.swiftUIColor)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(8)
    }
}

// MARK: - WalletMyPointView_Previews

struct WalletMyPointView_Previews: PreviewProvider {
    static var previews: some View {
        WalletMyPointView(point: 982_350)
    }
}
