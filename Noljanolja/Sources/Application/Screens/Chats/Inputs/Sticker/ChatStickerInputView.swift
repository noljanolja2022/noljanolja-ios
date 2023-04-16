//
//  ChatStickerInputView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/03/2023.
//
//

import Kingfisher
import SDWebImageSwiftUI
import SwiftUI

// MARK: - ChatStickerInputView

struct ChatStickerInputView<ViewModel: ChatStickerInputViewModelType>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    var selectedAction: ((StickerPack, Sticker) -> Void)?

    // MARK: State

    @State private var animatedSelectedSticker: Sticker?

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
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: .flexible(spacing: 20), count: 4),
                spacing: 20
            ) {
                ForEach(viewModel.stickerPack.stickers, id: \.imageFile) { sticker in
                    ZStack {
                        if animatedSelectedSticker == sticker {
                            AnimatedImage(
                                url: sticker.getImageURL(viewModel.stickerPack.id),
                                isAnimating: .constant(true)
                            )
                            .resizable()
                            .indicator(.activity)
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            WebImage(
                                url: sticker.getImageURL(viewModel.stickerPack.id),
                                isAnimating: .constant(false)
                            )
                            .resizable()
                            .indicator(.activity)
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .onTapGesture {
                        selectedAction?(viewModel.stickerPack, sticker)
                    }
                    .gesture(
                        LongPressGesture(minimumDuration: 0.5)
                            .sequenced(
                                before: DragGesture(minimumDistance: 0)
                            )
                            .onChanged { _ in
                                animatedSelectedSticker = sticker
                            }
                            .onEnded { _ in
                                animatedSelectedSticker = nil
                            }
                    )
                }
            }
            .padding(.horizontal, 16)
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
            Button("Download") {
                viewModel.downloadDataSubject.send()
            }
            .font(.system(size: 16, weight: .bold))
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(ColorAssets.primaryMain.swiftUIColor)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - ChatStickerInputView_Previews

struct ChatStickerInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChatStickerInputView(
            viewModel: ChatStickerInputViewModel(
                stickerPack: StickerPack(
                    id: 0, name: nil,
                    publisher: nil,
                    trayImageFile: "",
                    isAnimated: false,
                    stickers: []
                )
            )
        )
    }
}
