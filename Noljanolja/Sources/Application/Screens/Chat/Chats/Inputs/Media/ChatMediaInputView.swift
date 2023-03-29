//
//  ChatMediaInputView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/03/2023.
//
//

import SwiftUI

// MARK: - ChatMediaInputView

struct ChatMediaInputView<ViewModel: ChatMediaInputViewModelType>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    @Binding var type: ChatMediaInputType?
    @Binding var photoAssets: [PhotoAsset]
    var sendPhotoAction: (() -> Void)?
    var sendStickerAction: ((StickerPack, Sticker) -> Void)?

    // MARK: State

    var body: some View {
        switch type {
        case .photo:
            ChatPhotoInputView(
                viewModel: ChatPhotoInputViewModel(),
                photoAssets: $photoAssets,
                sendAction: { sendPhotoAction?() }
            )
        case .sticker:
            ChatStickerPacksInputView(
                viewModel: ChatStickerPacksInputViewModel(),
                selectedAction: sendStickerAction
            )
        case .none:
            EmptyView()
        }
    }
}

// MARK: - ChatMediaInputView_Previews

struct ChatMediaInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMediaInputView(
            viewModel: ChatMediaInputViewModel(),
            type: .constant(.sticker),
            photoAssets: Binding<[PhotoAsset]>(get: { [] }, set: { _ in })
        )
    }
}
