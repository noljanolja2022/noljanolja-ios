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
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBar(
                title: L10n.commonSetting,
                backButtonTitle: "",
                presentationMode: presentationMode,
                trailing: {},
                backgroundColor: themeManager.theme.primary200
            )
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
            .onReceive(viewModel.clearCacheResultAction) { _ in
                viewControllerHolder?.present(transitionStyle: .crossDissolve, builder: {
                    DialogView(model: .init(
                        image: ImageAssets.bgDialogClearCache.swiftUIImage,
                        title: L10n.commonSuccess + "!",
                        message: L10n.settingClearCacheSuccessDescription,
                        secondaryTitle: L10n.commonOk,
                        secondaryAction: {
                            viewControllerHolder?.dismissSelf()
                        }
                    ))
                    .environmentObject(themeManager)
                })
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
                .onTapGesture {
                    viewModel.navigationType = .changeUsername
                }

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
            AvatarView(
                url: viewModel.avatarURL,
                size: .init(width: 52, height: 52)
            )

            Text(L10n.chatSettingsChangeAvatar)
                .dynamicFont(.systemFont(ofSize: 12, weight: .bold))
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                .background(themeManager.theme.primary50)
                .cornerRadius(5)
                .onPress {
                    viewModel.fullScreenCoverType = .avatar
                }
        }
    }

    private func buildSectionSettings() -> some View {
        VStack(spacing: 5) {
            Text(L10n.permissionGoToSettings)
                .dynamicFont(.systemFont(ofSize: 14, weight: .semibold))
                .foregroundColor(.black)
                .padding(.bottom, 10)
                .fill(alignment: .leading)

            SettingItemView(
                title: L10n.settingPushNotification,
                isButton: false,
                content: {
                    Toggle("", isOn: $viewModel.isNotification)
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
                title: L10n.faq,
                action: {
                    viewModel.navigationType = .faq
                }
            )
        }
    }

    private func buildSectionAppColors() -> some View {
        VStack(spacing: 5) {
            Text(L10n.appColors)
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
                            Spacer()
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                                .visible(themeManager.theme == theme)
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
        case .changeUsername:
            ChangeUsernameView(
                viewModel: ChangeUsernameViewModel()
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
