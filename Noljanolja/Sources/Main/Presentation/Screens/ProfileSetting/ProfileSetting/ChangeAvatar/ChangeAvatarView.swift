//
//  ChangeAvatarView.swift
//  Noljanolja
//
//  Created by duydinhv on 06/12/2023.
//

import SwiftUI
import SwiftUINavigation
struct ChangeAvatarView<ViewModel: ChangeAvatarViewModel>: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var themeManager: AppThemeManager
    var body: some View {
        buildBodyView()
            .navigationBar(
                backButtonTitle: "",
                presentationMode: presentationMode,

                middle: { middle },
                trailing: { trailing },
                backgroundColor: themeManager.theme.primary200
            )
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) {
                Alert($0, action: { action in
                    switch action {
                    case let .confirmChange(image):
                        viewModel.confirmAction.send(image)
                    default:
                        break
                    }
                })
            }
            .onReceive(viewModel.backAction) { _ in
                presentationMode.wrappedValue.dismiss()
            }
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 0) {
            buildPreviewAvatar()
            buildPhotoPickerView()
        }
        .frame(maxWidth: UIScreen.mainWidth)
    }

    private func buildPreviewAvatar() -> some View {
        ZStack {
            if let avatarImage = viewModel.avatarImage {
                Image(uiImage: avatarImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .height(UIScreen.mainWidth)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(ColorAssets.neutralLight.swiftUIColor)
                    .height(UIScreen.mainWidth)
            }
        }
        .frame(maxWidth: .infinity)
        .background(ColorAssets.neutralGrey.swiftUIColor)
    }

    private func buildPhotoPickerView() -> some View {
        Group {
            HStack {
                Text(L10n.commonRecent)
                    .dynamicFont(.systemFont(ofSize: 16, weight: .medium))
                    .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)

                ImageAssets.icArrowDropDown.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)

            PhotoPickerView(selectAssets: $viewModel.photoAssets, isMultipleSelection: false)
        }
    }

    @ViewBuilder
    private var middle: some View {
        Text(L10n.commonAlbum)
            .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
    }

    @ViewBuilder
    private var trailing: some View {
        Text(L10n.commonDone)
            .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
            .foregroundColor(ColorAssets.systemBlue100.swiftUIColor)
            .onPress {
                viewModel.doneAction.send()
            }
    }
}
