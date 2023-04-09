//
//  ChatStickerPacksInputView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/03/2023.
//
//

import Kingfisher
import SDWebImageSwiftUI
import SwiftUI

// MARK: - ChatStickerPacksInputView

struct ChatStickerPacksInputView<ViewModel: ChatStickerPacksInputViewModelType>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    var selectedAction: ((StickerPack, Sticker) -> Void)?

    // MARK: State

    @State private var selectedStickerPackIndex = 0
    
    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .onAppear { viewModel.loadSubject.send() }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildHeader()
            buildStickers()
        }
    }

    private func buildHeader() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 24) {
                ForEach(Array(viewModel.stickerPacks.enumerated()), id: \.offset) { offset, stickerPack in
                    WebImage(url: stickerPack.getImageURL())
                        .resizable()
                        .indicator(.activity)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(4)
                        .background(
                            selectedStickerPackIndex == offset
                                ? ColorAssets.neutralLightGrey.swiftUIColor
                                : Color.clear
                        )
                        .cornerRadius(4)
                        .onTapGesture {
                            selectedStickerPackIndex = offset
                        }
                }
            }
        }
        .frame(height: 36)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private func buildStickers() -> some View {
        TabView(selection: $selectedStickerPackIndex) {
            ForEach(Array(viewModel.stickerPacks.enumerated()), id: \.offset) { offset, stickerPack in
                ChatStickerInputView(
                    viewModel: ChatStickerInputViewModel(
                        stickerPack: stickerPack
                    ),
                    selectedAction: selectedAction
                )
                .tag(offset)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

// MARK: - ChatStickerPacksInputView_Previews

struct ChatStickerPacksInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChatStickerPacksInputView(
            viewModel: ChatStickerPacksInputViewModel()
        )
    }
}
