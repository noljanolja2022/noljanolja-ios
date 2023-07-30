//
//  WalletNotiView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/05/2023.
//

import SwiftUI

// MARK: - WalletNotiView

struct WalletNotiView: View {
    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 16) {
            ImageAssets.bnWalletNoti.swiftUIImage
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .aspectRatio(2.7, contentMode: .fill)

            HStack(spacing: 8) {
                buildProgressView()

                Spacer()

                Button(
                    action: {},
                    label: {
                        Text(L10n.walletAttendNow)
                            .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                            .height(32)
                            .padding(.horizontal, 24)
                            .foregroundColor(ColorAssets.neutralRawLight.swiftUIColor)
                            .background(ColorAssets.primaryGreen300.swiftUIColor)
                            .cornerRadius(4)
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .background(
            ColorAssets.neutralLight.swiftUIColor
                .cornerRadius(12)
                .padding(.top, 24)
                .shadow(
                    color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.2),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
    }

    private func buildProgressView() -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                Text(L10n.walletMyAttendance)
                    .dynamicFont(.systemFont(ofSize: 12, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

                Spacer()

                HStack(spacing: 4) {
                    Text("12")
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

                    Text("/")
                        .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)

                    Text("30")
                        .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                }
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Spacer()
                        .frame(maxWidth: .infinity)
                        .height(6)
                        .background(ColorAssets.neutralLightGrey.swiftUIColor)
                        .cornerRadius(3)
                    Spacer()
                        .frame(width: proxy.size.width * (12 / 30))
                        .height(6)
                        .background(ColorAssets.secondaryYellow200.swiftUIColor)
                        .cornerRadius(3)
                }
            }
        }
    }
}

// MARK: - WalletNotiView_Previews

struct WalletNotiView_Previews: PreviewProvider {
    static var previews: some View {
        WalletNotiView()
    }
}