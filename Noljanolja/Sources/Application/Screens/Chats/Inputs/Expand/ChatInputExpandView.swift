//
//  ChatInputExpandView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/03/2023.
//
//

import SwiftUI

// MARK: - ChatInputExpandView

struct ChatInputExpandView<ViewModel: ChatInputExpandViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    @Binding var expandType: ChatInputExpandType?
    @Binding var photoAssets: [PhotoAsset]

    // MARK: State

    var body: some View {
        switch expandType {
        case .menu:
            ChatInputExpandMenuView(
                viewModel: ChatInputExpandMenuViewModel(
                    delegate: viewModel
                ),
                expandType: $expandType
            )
        case .sticker:
            ChatStickerPacksInputView(
                viewModel: ChatStickerPacksInputViewModel(
                    delegate: viewModel
                )
            )
        case .images:
            ChatPhotoInputView(
                viewModel: ChatPhotoInputViewModel(),
                photoAssets: $photoAssets
            )
        case .none:
            EmptyView()
        }
    }
}

// MARK: - ChatInputExpandView_Previews

struct ChatInputExpandView_Previews: PreviewProvider {
    static var previews: some View {
        ChatInputExpandView(
            viewModel: ChatInputExpandViewModel(),
            expandType: .constant(.sticker),
            photoAssets: .constant([])
        )
    }
}
