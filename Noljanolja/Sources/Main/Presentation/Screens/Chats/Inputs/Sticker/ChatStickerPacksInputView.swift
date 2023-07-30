//
//  ChatStickerPacksInputView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/03/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - ChatStickerPacksInputView

struct ChatStickerPacksInputView<ViewModel: ChatStickerPacksInputViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @State private var selectedStickerPackIndex = 0
    
    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildHeader()
            buildStickers()
        }
    }

    private func buildHeader() -> some View {
        HStack(spacing: 4) {
            buildStickerList()
            buildStoreView()
        }
        .frame(height: 36)
        .padding(.vertical, 8)
    }

    private func buildStickerList() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 24) {
                buildGifView()
                buildRecentView()

                ForEach(viewModel.stickerPacks.indices, id: \.self) { index in
                    buildHeaderItem(
                        index: index,
                        stickerPack: viewModel.stickerPacks[index]
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func buildGifView() -> some View {
        ImageAssets.icChatGif.swiftUIImage
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(4)
    }

    private func buildRecentView() -> some View {
        ImageAssets.icChatStickerRecent.swiftUIImage
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(4)
    }

    private func buildHeaderItem(index: Int, stickerPack: StickerPack) -> some View {
        WebImage(
            url: stickerPack.getImageURL(),
            context: [
                .imageTransformer: SDImageResizingTransformer(
                    size: CGSize(width: 36 * 3, height: 36 * 3),
                    scaleMode: .aspectFill
                )
            ]
        )
        .resizable()
        .indicator(.activity)
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(2)
        .background(
            selectedStickerPackIndex == index
                ? ColorAssets.neutralLightGrey.swiftUIColor
                : Color.clear
        )
        .cornerRadius(4)
        .onTapGesture {
            selectedStickerPackIndex = index
        }
    }

    private func buildStoreView() -> some View {
        ImageAssets.icChatStickerStore.swiftUIImage
            .resizable()
            .scaledToFit()
            .padding(4)
    }

    @ViewBuilder
    private func buildStickers() -> some View {
        TabView(selection: $selectedStickerPackIndex) {
            ForEach(viewModel.stickerPacks.indices, id: \.self) { index in
                ChatStickerInputView(
                    viewModel: ChatStickerInputViewModel(
                        stickerPack: viewModel.stickerPacks[index],
                        delegate: viewModel
                    )
                )
                .tag(index)
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
