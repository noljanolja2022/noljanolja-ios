//
//  MessageItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import SDWebImageSwiftUI
import SwiftUI
import SwiftUIX

// MARK: - NormalMessageView

struct NormalMessageView: View {
    let model: NormalMessageModel
    let action: ((NormalMessageModel.ActionType) -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(alignment: .top, spacing: 8) {
            buildAvatarView()
            buildContentView()
        }
        .padding(.horizontal, 16)
        .padding(.top, model.topPadding)
    }

    @ViewBuilder
    private func buildAvatarView() -> some View {
        WebImage(
            url: URL(string: model.senderAvatar),
            context: [
                .imageTransformer: SDImageResizingTransformer(
                    size: CGSize(width: 32 * 3, height: 32 * 3),
                    scaleMode: .aspectFill
                )
            ]
        )
        .resizable()
        .scaledToFill()
        .frame(width: 32, height: 32)
        .background(ColorAssets.neutralGrey.swiftUIColor)
        .cornerRadius(12)
        .visible(model.senderAvatarVisibility)
    }

    private func buildContentView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            buildSenderNameView()
            buildMessageContentMainView()
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func buildSenderNameView() -> some View {
        Text(model.senderName)
            .dynamicFont(.systemFont(ofSize: 11, weight: .medium))
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 16)
            .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            .visible(model.senderNameVisibility)
    }

    private func buildMessageContentMainView() -> some View {
        HStack(alignment: .bottom, spacing: 4) {
            Spacer(minLength: UIScreen.main.bounds.width / 5)

            buildMessageContentView()
                .environment(\.layoutDirection, .leftToRight)
        }
        .environment(\.layoutDirection, model.isSendByCurrentUser ? .leftToRight : .rightToLeft)
    }

    private func buildMessageContentView() -> some View {
        VStack(
            alignment: model.reactionsModel?.horizontalAlignment ?? .center,
            spacing: 0
        ) {
            if let replyToMessage = model.replyToMessage {
                PreviewReplyMessageView(
                    model: replyToMessage,
                    background: ColorAssets.neutralLightGrey.swiftUIColor,
                    isExpand: false,
                    cornerRadius: 8,
                    isRemoveEnabled: false
                )
                .opacity(0.75)
                .padding(.bottom, -12)
                .padding(.top, 4)
            }

            MessageContentView(
                model: model.content,
                action: {
                    switch $0 {
                    case let .openURL(urlString):
                        action?(.openURL(urlString))
                    case .openImages:
                        action?(.openImages(model.message))
                    case let .reaction(reactionIcon):
                        action?(.reaction(model.message, reactionIcon))
                    case let .openVideoDetail(model):
                        action?(.openVideoDetail(model))
                    case let .openMessageQuickReactionDetail(geometryProxy):
                        action?(.openMessageQuickReactionDetail(model.message, geometryProxy))
                    case let .openMessageActionDetail(geometryProxy):
                        action?(.openMessageActionDetail(model, geometryProxy))
                    }
                }
            )

            MessageReactionsView(
                model: model.reactionsModel,
                quickTapAction: {
                    action?(.reaction(model.message, $0))
                },
                quickLongPressAction: {
                    action?(.openMessageQuickReactionDetail(model.message, $0))
                }
            )
            .padding(.top, -12)
        }
    }
}
