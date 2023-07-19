//
//  ChatPhotoInputView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/03/2023.
//
//

import SwiftUI

// MARK: - ChatPhotoInputView

struct ChatPhotoInputView<ViewModel: ChatPhotoInputViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    @Binding var photoAssets: [PhotoAsset]

    // MARK: State

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.viewState != .content },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildContentView() -> some View {
        PhotoPickerView(selectAssets: $photoAssets)
    }
}

extension ChatPhotoInputView {
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildEmptyView() -> some View {
        EmptyView()
    }

    private func buildErrorView() -> some View {
        VStack(spacing: 16) {
            Text(L10n.permissionRequiredDescription)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)

            Button(L10n.permissionGoToSettings) {
                guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            .font(.system(size: 16, weight: .bold))
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(ColorAssets.primaryGreen200.swiftUIColor)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - ChatPhotoInputView_Previews

struct ChatPhotoInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChatPhotoInputView(
            viewModel: ChatPhotoInputViewModel(), photoAssets: .constant([])
        )
    }
}
