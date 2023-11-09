//
//  HeaderVideoView.swift
//  Noljanolja
//
//  Created by duydinhv on 07/11/2023.
//

import SwiftUI

// MARK: - HeaderVideoView

struct HeaderVideoView: View {
    var searchAction: (() -> Void)?
    var notificationAction: (() -> Void)?
    var settingAction: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                ImageAssets.logo.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .height(60)
                Spacer()
                HStack(spacing: 20) {
                    Button(
                        action: { searchAction?() },
                        label: {
                            ImageAssets.icSearch.swiftUIImage
                                .resizable()
                                .scaledToFit()
                        }
                    )

                    Button(
                        action: { notificationAction?() },
                        label: {
                            ImageAssets.icNotifications.swiftUIImage
                                .resizable()
                                .scaledToFit()
                        }
                    )

                    Button(
                        action: { settingAction?() },
                        label: {
                            ImageAssets.icSettingFill.swiftUIImage
                                .resizable()
                                .scaledToFit()
                        }
                    )
                }
                .height(24)
                .padding(.top, 10)
            }
            ZStack {
                Text("Let's Get ").foregroundColor(.label)
                    + Text("Points \n").foregroundColor(ColorAssets.primaryGreen200.swiftUIColor).fontWeight(.bold)
                    + Text("By ").foregroundColor(.label)
                    + Text("Watching").foregroundColor(ColorAssets.secondaryYellow400.swiftUIColor).fontWeight(.bold)
            }
            .dynamicFont(.systemFont(ofSize: 24))
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 4)
    }
}

// MARK: - HeaderVideoView_Previews

struct HeaderVideoView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderVideoView()
    }
}
