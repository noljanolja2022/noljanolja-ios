//
//  MessageContentView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import SwiftUI

// MARK: - MessageContentView

struct MessageContentView: View {
    var messageContent: ChatMessageItemModel.ContentType?

    var body: some View {
        buildBody()
    }

    @ViewBuilder
    private func buildBody() -> some View {
        switch messageContent {
        case let .plaintext(model):
            TextMessageContentView(contentItemModel: model)
                .background(.red)
        case let .photo(model):
            PhotoMessageContentView(contentItemModel: model)
                .background(.green)
        case let .sticker(model):
            StickerMessageContentView(contentItemModel: model)
                .background(.blue)
        case .none:
            EmptyView()
        }
    }
}

// MARK: - MessageContentView_Previews

struct MessageContentView_Previews: PreviewProvider {
    static var previews: some View {
        MessageContentView(
            messageContent: .plaintext(TextMessageContentModel(
                isSenderMessage: true,
                message: "Hello, world"
            ))
        )
    }
}
