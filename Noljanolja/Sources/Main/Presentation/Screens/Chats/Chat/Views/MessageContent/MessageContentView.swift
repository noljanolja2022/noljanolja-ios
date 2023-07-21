//
//  MessageContentView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import SwiftUI

// MARK: - MessageContentView

struct MessageContentView: View {
    let model: NormalMessageModel.ContentType?
    var action: ((NormalMessageModel.ContentActionType) -> Void)?

    var body: some View {
        buildBody()
    }

    @ViewBuilder
    private func buildBody() -> some View {
        switch model {
        case let .plaintext(model):
            TextMessageContentView(
                model: model,
                action: {
                    switch $0 {
                    case let .openURL(urlString):
                        action?(.openURL(urlString))
                    case let .reaction(reactionIcon):
                        action?(.reaction(reactionIcon))
                    case let .openMessageQuickReactionDetail(geometryProxy):
                        action?(.openMessageQuickReactionDetail(geometryProxy))
                    case let .openMessageActionDetail(geometryProxy):
                        action?(.openMessageActionDetail(geometryProxy))
                    }
                }
            )
        case let .photo(model):
            PhotoMessageContentView(
                model: model,
                action: {
                    switch $0 {
                    case .openImages:
                        action?(.openImages)
                    case let .reaction(reactionIcon):
                        action?(.reaction(reactionIcon))
                    case let .openMessageQuickReactionDetail(geometryProxy):
                        action?(.openMessageQuickReactionDetail(geometryProxy))
                    case let .openMessageActionDetail(geometryProxy):
                        action?(.openMessageActionDetail(geometryProxy))
                    }
                }
            )
        case let .sticker(model):
            StickerMessageContentView(
                model: model,
                action: {
                    switch $0 {
                    case let .reaction(reactionIcon):
                        action?(.reaction(reactionIcon))
                    case let .openMessageQuickReactionDetail(geometryProxy):
                        action?(.openMessageQuickReactionDetail(geometryProxy))
                    case let .openMessageActionDetail(geometryProxy):
                        action?(.openMessageActionDetail(geometryProxy))
                    }
                }
            )
        case .none:
            EmptyView()
        }
    }
}
