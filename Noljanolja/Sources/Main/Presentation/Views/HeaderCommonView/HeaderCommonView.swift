//
//  HeaderView.swift
//  Noljanolja
//
//  Created by kii on 13/11/2023.
//

import SwiftUI

// MARK: - HeaderCommonView

struct HeaderCommonView<Content: View>: View {
    var searchAction: (() -> Void)?
    var notificationAction: (() -> Void)?
    var settingAction: (() -> Void)?
    var content: () -> Content
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                ImageAssets.logo.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .height(60)
                Spacer()
                HStack(spacing: 20) {
                    if let searchAction {
                        Button(
                            action: { searchAction() },
                            label: {
                                ImageAssets.icSearch.swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                            }
                        )
                    }
                    if let notificationAction {
                        Button(
                            action: { notificationAction() },
                            label: {
                                ImageAssets.icNotifications.swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                            }
                        )
                    }
                    if let settingAction {
                        Button(
                            action: { settingAction() },
                            label: {
                                ImageAssets.icSettingFill.swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                            }
                        )
                    }
                }
                .height(24)
                .padding(.top, 10)
            }
            content()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 4)
    }
}

// MARK: - HeaderCommonView_Previews

struct HeaderCommonView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderCommonView { EmptyView() }
    }
}
