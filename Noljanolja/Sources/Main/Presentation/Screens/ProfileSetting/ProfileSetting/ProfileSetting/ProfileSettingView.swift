//
//  ProfileSettingView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import AlertToast
import SDWebImageSwiftUI
import SwiftUI
import SwiftUINavigation
import SwiftUIX

// MARK: - ProfileSettingView

struct ProfileSettingView<ViewModel: ProfileSettingViewModel>: View {
    // MARK: Dependencies

    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    @EnvironmentObject var themeManager: AppThemeManager

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBar(title: L10n.commonSetting, backButtonTitle: "", presentationMode: presentationMode, trailing: {})
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
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
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
            .toast(isPresenting: $viewModel.isShowFinishAvatar, duration: 1) {
                AlertToast(
                    displayMode: .alert,
                    type: .image(ImageAssets.icCheckmarkRect.name, .clear),
                    style: .style(backgroundColor: .clear)
                )
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
                VStack(spacing: 32) {
                    buildUserInfoView()

                    buildSectionSettings()

                    buildSectionAppColors()

                    buildAppInfoView()
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
            }
            .frame(maxHeight: .infinity)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)

            buildLogOutView()
        }
    }

    private func buildUserInfoView() -> some View {
        VStack(spacing: 15) {
            buildAvatarView()

            ItemProfileView(title: L10n.settingRanking, content: "", ranking: viewModel.ranking)

            ItemProfileView(title: L10n.settingName, content: viewModel.name)

            ItemProfileView(title: L10n.settingPhoneNumber, content: viewModel.phoneNumber)

            ItemProfileView(title: L10n.updateProfileGender, content: viewModel.gender?.title ?? "")
        }
        .padding(.vertical, 17)
        .padding(.horizontal, 24)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(10)
    }

    private func buildAvatarView() -> some View {
        VStack(spacing: 10) {
            WebImage(
                url: URL(string: viewModel.avatarURL ?? ""),
                options: .refreshCached,
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(width: 52 * 3, height: 52 * 3),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .placeholder(ImageAssets.icAvatarPlaceholder.swiftUIImage)
            .indicator(.activity)
            .scaledToFill()
            .frame(width: 52, height: 52)
            .cornerRadius(26)

            Text(L10n.chatSettingsChangeAvatar)
                .dynamicFont(.systemFont(ofSize: 12, weight: .bold))
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .background(themeManager.theme.primary50)
                .cornerRadius(5)
                .onPress {
                    viewModel.fullScreenCoverType = .avatar
                }
        }
    }

    private func buildSectionSettings() -> some View {
        VStack(spacing: 5) {
            Text("Settings")
                .dynamicFont(.systemFont(ofSize: 14, weight: .semibold))
                .foregroundColor(.black)
                .padding(.bottom, 10)
                .fill(alignment: .leading)

            SettingItemView(
                title: L10n.settingPushNotification,
                content: {
                    Toggle("", isOn: .constant(true))
                        .toggleStyle(SwitchToggleStyle(tint: themeManager.theme.primary50))
                        .labelsHidden()
                }
            )

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
            SettingItemView(
                title: "FAQ",
                action: {
                    viewModel.navigationType = .faq
                }
            )
        }
    }

    private func buildSectionAppColors() -> some View {
        VStack(spacing: 5) {
            Text("App colors")
                .dynamicFont(.systemFont(ofSize: 14, weight: .semibold))
                .foregroundColor(.black)
                .padding(.bottom, 5)
                .fill(alignment: .leading)

            ForEach(AppTheme.allCases, id: \.self) { theme in
                SettingItemView(
                    content: {
                        HStack(spacing: 12) {
                            theme.primary200
                                .frame(width: 24, height: 24)
                                .clipShape(Circle())
                            Text(theme.title)
                                .dynamicFont(.systemFont(ofSize: 12))
                                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        }
                        .fill(alignment: .leading)
                    }
                ) {
                    themeManager.changeThemeAction.send(theme)
                }
            }
        }
    }

    private func buildAppInfoView() -> some View {
        Group {
            Text(L10n.settingCurrentVersion(viewModel.appVersion))
                .dynamicFont(.systemFont(ofSize: 12))
                .padding(.vertical, 10)
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
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
        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
        .padding(.vertical, 16)
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
        case .changeAvatarAlbum:
            ChangeAvatarView(viewModel:
                ChangeAvatarViewModel(delegate: viewModel)
            )
        }
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<SettingFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case let .imagePickerView(sourceType):
            ImagePicker(image: $viewModel.image)
                .sourceType(sourceType)
                .allowsEditing(true)
                .introspectViewController {
                    switch sourceType {
                    case .photoLibrary, .savedPhotosAlbum:
                        break
                    case .camera:
                        $0.view.backgroundColor = .black
                    @unknown default:
                        break
                    }
                }
        case .avatar:
            BottomSheet {
                ProfileActionView(
                    viewModel: ProfileActionViewModel(delegate: viewModel)
                )
            }
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
