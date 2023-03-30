//
//  ChatPhotoInputView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/03/2023.
//
//

import SwiftUI

// MARK: - ChatPhotoInputView

struct ChatPhotoInputView<ViewModel: ChatPhotoInputViewModelType>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    @State private var photoAssets = [PhotoAsset]()
    var sendAction: (([PhotoAsset]) -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 0) {
            buildContentView()
                .statefull(
                    state: $viewModel.viewState,
                    isEmpty: { viewModel.viewState != .content },
                    loading: buildLoadingView,
                    empty: buildEmptyView,
                    error: buildErrorView
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    viewModel.loadDataSubject.send()
                }
        }
    }

    private func buildContentView() -> some View {
        ZStack(alignment: .bottom) {
            PhotoPickerView(selectAssets: $photoAssets)

            if !photoAssets.isEmpty {
                Button(
                    action: {
                        sendAction?(photoAssets)
                        photoAssets = []
                    },
                    label: {
                        Text("Send")
                            .frame(maxWidth: .infinity)
                    }
                )
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                .background(ColorAssets.primaryYellowMain.swiftUIColor)
                .cornerRadius(8)
                .padding(.horizontal, 16)
            }
        }
    }

    private func buildLoadingView() -> some View {
        LoadingView()
    }

    private func buildEmptyView() -> some View {
        EmptyView()
    }

    private func buildErrorView() -> some View {
        VStack(spacing: 16) {
            Text("Don't have permission. Please grant permisison")
                .font(.system(size: 14))

            Button("Open app setting") {
                guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            .font(.system(size: 16, weight: .bold))
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(ColorAssets.primaryYellowMain.swiftUIColor)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - ChatPhotoInputView_Previews

struct ChatPhotoInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChatPhotoInputView(
            viewModel: ChatPhotoInputViewModel()
        )
    }
}
