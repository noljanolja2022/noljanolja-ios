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
    
    var sendPhotoAction: (([PhotoAsset]) -> Void)?
    var sendStickerAction: ((StickerPack, Sticker) -> Void)?

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
                viewModel: ChatStickerPacksInputViewModel(),
                selectedAction: sendStickerAction
            )
        case .images:
            ChatPhotoInputView(
                viewModel: ChatPhotoInputViewModel(),
                sendAction: { sendPhotoAction?($0) }
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
            expandType: .constant(.sticker)
        )
    }
}
