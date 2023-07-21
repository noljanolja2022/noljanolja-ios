//
//  ProfileSettingView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import SwiftUI

// MARK: - ProfileSettingView

struct ProfileSettingView<ViewModel: ProfileSettingViewModel>: View {
    // MARK: Dependencies
    
    @StateObject var viewModel: ViewModel

    // MARK: State

    @EnvironmentObject private var progressHUBState: ProgressHUBState

    var body: some View {
        buildBodyView()
    }
    
    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.commonSetting)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .onChange(of: viewModel.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
            .alert(item: $viewModel.alertState) {
                Alert($0) { action in
                    switch action {
                    case .clearCache:
                        viewModel.clearCacheAction.send()
                    case .signOut:
                        viewModel.signOutAction.send()
                    case .none:
                        break
                    }
                }
            }
    }

    private func buildMainView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLinks()
        }
    }
    
    private func buildContentView() -> some View {
        VStack(spacing: 12) {
            ScrollView {
                VStack(spacing: 16) {
                    buildUserInfoView()

                    Divider()
                        .frame(height: 1)
                        .overlay(ColorAssets.neutralLightGrey.swiftUIColor)

                    buildPushNotiView()

                    Divider()
                        .frame(height: 1)
                        .overlay(ColorAssets.neutralLightGrey.swiftUIColor)

                    buildAppSettingView()

                    Divider()
                        .frame(height: 1)
                        .overlay(ColorAssets.neutralLightGrey.swiftUIColor)

                    buildAppInfoView()
                }
                .padding(16)
            }
            .frame(maxHeight: .infinity)

            buildLogOutView()
        }
    }

    private func buildUserInfoView() -> some View {
        VStack(spacing: 0) {
            SettingItemView(
                title: L10n.settingExchangeAccountManagement,
                content: {
                    ImageAssets.icArrowRight.swiftUIImage
                        .frame(width: 16, height: 16)
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            )
            SettingItemView(
                title: L10n.settingName,
                content: {
                    HStack(spacing: 12) {
                        Text(viewModel.name)
                            .font(.system(size: 16, weight: .bold))

                        ImageAssets.icEdit.swiftUIImage
                            .frame(width: 24, height: 24)
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    }
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                },
                action: {
                    viewModel.navigationType = .updateCurrentUser
                }
            )
            SettingItemView(
                title: L10n.settingPhoneNumber,
                content: {
                    Text(viewModel.phoneNumber)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            )
        }
    }

    private func buildPushNotiView() -> some View {
        VStack(spacing: 0) {
            SettingItemView(
                title: L10n.settingPushNotification,
                content: {
                    Toggle("", isOn: .constant(true))
                }
            )
        }
    }

    private func buildAppSettingView() -> some View {
        VStack(spacing: 0) {
            SettingItemView(
                title: L10n.settingClearCacheData,
                action: {
                    viewModel.clearCacheConfirmAction.send()
                }
            )
            SettingItemView(
                title: L10n.settingOpenSourceLicence,
                action: {
                    viewModel.navigationType = .sourceLicense
                }
            )
        }
    }

    private func buildAppInfoView() -> some View {
        VStack(spacing: 0) {
            SettingItemView(
                title: "FAQ",
                action: {
                    viewModel.navigationType = .faq
                }
            )
            SettingItemView(
                title: L10n.settingCurrentVersion(viewModel.appVersion)
            )
        }
    }

    private func buildLogOutView() -> some View {
        Button(
            L10n.commonLogOut.uppercased(),
            action: {
                viewModel.signOutAction.send()
            }
        )
        .buttonStyle(PrimaryButtonStyle())
        .font(.system(size: 16, weight: .bold))
        .padding(.horizontal, 16)
    }
    
    private func buildNavigationLinks() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: {
                buildNavigationDestinationView($0)
            },
            label: {
                EmptyView()
            }
        )
    }
    
    @ViewBuilder
    private func buildNavigationDestinationView(
        _ type: Binding<SettingNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case .updateCurrentUser:
            UpdateCurrentUserView(
                viewModel: UpdateCurrentUserViewModel()
            )
        case .sourceLicense:
            SourceLicenseView(
                viewModel: SourceLicenseViewModel()
            )
        case .faq:
            FAQView(viewModel: FAQViewModel())
        }
    }
}

// MARK: - ProfileSettingView_Previews

struct ProfileSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingView(
            viewModel: ProfileSettingViewModel()
        )
    }
}
