//
//  NotificationSettingView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/05/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - NotificationSettingView

struct NotificationSettingView<ViewModel: NotificationSettingViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack(alignment: .bottom) {
            Spacer()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    ColorAssets.neutralDarkGrey.swiftUIColor
                        .opacity(0.4)
                        .edgesIgnoringSafeArea(.top)
                )
                .onTapGesture {
                    withoutAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            buildContentView()
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 24) {
            ZStack(alignment: .topTrailing) {
                ImageAssets.icNotifications.swiftUIImage
                    .resizable()
                    .frame(width: 38, height: 38)
                    .foregroundColor(ColorAssets.primaryGreen200.swiftUIColor)
                    .frame(width: 58, height: 58)
                    .background(ColorAssets.neutralLightGrey.swiftUIColor)
                    .cornerRadius(29)
                    .frame(maxWidth: .infinity)

                Button(
                    action: {
                        withoutAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    label: {
                        ImageAssets.icClose.swiftUIImage
                            .resizable()
                            .padding(4)
                            .frame(width: 24, height: 24)
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    }
                )
            }

            VStack(spacing: 12) {
                Text(L10n.permissionNotificationTitle)
                    .dynamicFont(.systemFont(ofSize: 22, weight: .medium))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

                Text(L10n.permissionNotificationDescription)
                    .dynamicFont(.systemFont(ofSize: 12))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }

            Button(
                L10n.permissionGoToSettings.uppercased(),
                action: {
                    guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    withoutAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
            .buttonStyle(PrimaryButtonStyle())
            .dynamicFont(.systemFont(ofSize: 16, weight: .bold))

            Spacer()
                .frame(
                    height: UIApplication.shared.rootKeyWindow?.safeAreaInsets.bottom ?? 0
                )
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 24)
        .padding(.horizontal, 16)
        .background(
            ColorAssets.neutralLight.swiftUIColor
                .edgesIgnoringSafeArea(.bottom)
        )
        .cornerRadius([.topLeading, .topTrailing], 24)
    }
}

// MARK: - NotificationSettingView_Previews

struct NotificationSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingView(viewModel: NotificationSettingViewModel())
    }
}
