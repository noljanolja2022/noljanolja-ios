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
    let action: ((ChatItemActionType) -> Void)?

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
            buildMessageContentView()
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func buildSenderNameView() -> some View {
        Text(model.senderName)
            .font(.system(size: 11, weight: .medium))
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 16)
            .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            .visible(model.senderNameVisibility)
    }

    private func buildMessageContentView() -> some View {
        HStack(alignment: .bottom, spacing: 4) {
            Spacer(minLength: UIScreen.main.bounds.width / 5)

            MessageContentView(
                model: model.content,
                action: action
            )
            .environment(\.layoutDirection, .leftToRight)
        }
        .environment(\.layoutDirection, model.isSendByCurrentUser ? .leftToRight : .rightToLeft)
    }
}
