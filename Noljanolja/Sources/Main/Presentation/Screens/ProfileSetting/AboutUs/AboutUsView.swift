//
//  AboutUsView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/05/2023.
//
//

import SwiftUI

// MARK: - AboutUsView

struct AboutUsView<ViewModel: AboutUsViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBar(title: L10n.settingAboutUsTitle)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildMainView() -> some View {
        ScrollView {
            VStack(spacing: 16) {
                AboutUsItemView(
                    title: L10n.settingCompanyNameTitle,
                    description: "PNP&YY Co., Ltd."
                )

                Divider()
                    .frame(height: 1)
                    .overlay(ColorAssets.neutralLightGrey.swiftUIColor)

                AboutUsItemView(
                    title: L10n.settingRepresentativeTitle,
                    description: "Seungdae Park"
                )

                Divider()
                    .frame(height: 1)
                    .overlay(ColorAssets.neutralLightGrey.swiftUIColor)

                AboutUsItemView(
                    title: L10n.settingAddressTitle,
                    description: "Room 809, Ace Gasan Tower, 121 Digital-ro, Geumcheon-gu, Seoul"
                )

                Divider()
                    .frame(height: 1)
                    .overlay(ColorAssets.neutralLightGrey.swiftUIColor)

                AboutUsItemView(
                    title: L10n.settingPhoneCallTitle,
                    description: "070-7733-1193"
                )

                Divider()
                    .frame(height: 1)
                    .overlay(ColorAssets.neutralLightGrey.swiftUIColor)

                AboutUsItemView(
                    title: L10n.settingCompanyNameTitle,
                    description: "881-86-01396"
                )
            }
            .padding(16)
        }
    }
}

// MARK: - AboutUsView_Previews

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView(viewModel: AboutUsViewModel())
    }
}
