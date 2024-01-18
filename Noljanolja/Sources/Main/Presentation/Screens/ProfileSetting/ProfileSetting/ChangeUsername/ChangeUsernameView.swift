//
//  ChangeUsernameView.swift
//  Noljanolja
//
//  Created by duydinhv on 18/01/2024.
//

import SwiftUI
import SwiftUINavigation
import SwiftUIX

struct ChangeUsernameView<ViewModel: ChangeUsernameViewModel>: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    @StateObject private var keyboard = Keyboard.main
    @EnvironmentObject var themeManager: AppThemeManager

    var body: some View {
        buildBodyView()
            .navigationBar(
                title: L10n.commonName,
                backButtonTitle: "",
                presentationMode: presentationMode,
                trailing: {},
                backgroundColor: themeManager.theme.primary200
            )
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
            .onReceive(viewModel.changeUsernameSucces) { _ in
                presentationMode.wrappedValue.dismiss()
            }
    }

    private func buildBodyView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                TextField(L10n.commonName, text: $viewModel.name)
                    .dynamicFont(.systemFont(ofSize: 16))
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 5)

                Button {
                    viewModel.name = ""
                } label: {
                    ImageAssets.icCancel.swiftUIImage
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .frame(height: 40)
                .padding(.horizontal, 4)
            }
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(ColorAssets.neutralDarkGrey.swiftUIColor, lineWidth: 1)
            )

            Text(L10n.noticeChangeUsername)
                .dynamicFont(.systemFont(ofSize: 12))

            Spacer()

            Button(
                L10n.commonDone.uppercased(),
                action: {
                    viewModel.updateCurrentUserAction.send()
                }
            )
            .buttonStyle(PrimaryButtonStyle(
                isEnabled: !viewModel.name.isEmpty,
                disabledBackgroundColor: ColorAssets.neutralLightGrey.swiftUIColor
            ))
            .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 16)
        .background(ColorAssets.neutralLight.swiftUIColor)
    }
}
