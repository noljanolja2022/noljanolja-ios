//
//  PreviewReplyMessageView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/07/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - PreviewReplyMessageView

struct PreviewReplyMessageView: View {
    var model: PreviewReplyMessageModel
    var background: Color = .clear
    var isExpand = true
    var cornerRadius: CGFloat = 0
    var isRemoveEnabled = true
    var removeAction: (() -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(spacing: 0) {
            buildContentView()
            buildSpacer()
            buildRemoveView()
        }
        .padding(.top, 8)
        .padding(.bottom, 8 + cornerRadius)
        .padding(.horizontal, 16)
        .background(background)
        .cornerRadius(cornerRadius)
        .border(ColorAssets.primaryGreen200.swiftUIColor, width: 1, cornerRadius: cornerRadius)
    }

    private func buildContentView() -> some View {
        HStack(spacing: 8) {
            buildImageView()
            VStack(alignment: .leading, spacing: 4) {
                buildSenderView()
                buildMessageView()
            }
        }
    }

    @ViewBuilder
    private func buildSpacer() -> some View {
        if isExpand {
            Spacer()
        }
    }

    @ViewBuilder
    private func buildRemoveView() -> some View {
        if isRemoveEnabled {
            Button(
                action: {
                    removeAction?()
                },
                label: {
                    ImageAssets.icClose.swiftUIImage
                        .resizable()
                        .padding(6)
                        .frame(width: 24, height: 24)
                        .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                }
            )
        }
    }

    @ViewBuilder
    private func buildImageView() -> some View {
        if let imageURL = model.imageURL {
            GeometryReader { geometry in
                WebImage(
                    url: imageURL,
                    context: [
                        .imageTransformer: SDImageResizingTransformer(
                            size: CGSize(
                                width: geometry.size.width * 3,
                                height: geometry.size.height * 3
                            ),
                            scaleMode: .aspectFill
                        )
                    ]
                )
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            }
            .frame(width: 40, height: 40)
            .clipped()
        }
    }
    
    @ViewBuilder
    private func buildSenderView() -> some View {
        if let senderName = model.senderName, !senderName.isEmpty {
            Text(senderName)
                .font(.system(size: 12, weight: .bold))
                .multilineTextAlignment(.leading)
                .frame(alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
    }

    @ViewBuilder
    private func buildMessageView() -> some View {
        if let message = model.message {
            Text(message)
                .font(.system(size: 12))
                .lineLimit(1)
                .multilineTextAlignment(.leading)
                .frame(alignment: .leading)
                .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
        }
    }
}
