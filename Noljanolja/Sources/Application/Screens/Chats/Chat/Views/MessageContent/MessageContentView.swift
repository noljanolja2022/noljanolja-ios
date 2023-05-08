//
//  MessageContentView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import SwiftUI

// MARK: - MessageContentView

struct MessageContentView: View {
    var model: NormalMessageModel.ContentType?
    var action: ((ChatItemActionType) -> Void)?

    var body: some View {
        buildBody()
    }

    @ViewBuilder
    private func buildBody() -> some View {
        switch model {
        case let .plaintext(model):
            TextMessageContentView(
                model: model,
                action: action
            )
        case let .photo(model):
            PhotoMessageContentView(
                model: model,
                action: action
            )
        case let .sticker(model):
            StickerMessageContentView(
                contentItemModel: model
            )
        case .none:
            EmptyView()
        }
    }
}
