//
//  ReceiverMessageView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Kingfisher
import SDWebImageSwiftUI
import SwiftUI

// MARK: - ReceiverMessageView

struct ReceiverMessageView: View {
    var model: MessageChatItemModel
    var action: ((ChatItemActionType) -> Void)?

    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            if model.positionType == .all
                || model.positionType == .first {
                WebImage(
                    url: URL(string: model.avatar ?? ""),
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
            }

            HStack(alignment: .bottom, spacing: 4) {
                MessageContentView(
                    messageContent: model.content,
                    action: action
                )
                .receiverMessageCornerRadius(model.positionType)

                Text(model.date.string(withFormat: "HH:mm"))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
            }
            .padding(
                .top,
                model.positionType == .all
                    || model.positionType == .first
                    ? 16
                    : 0
            )

            Spacer(minLength: 32)
        }
        .padding(
            .leading,
            model.positionType == .all
                || model.positionType == .first
                ? 16
                : 52
        )
        .padding(.trailing, 16)
        .padding(
            .top,
            model.positionType == .middle
                || model.positionType == .last
                ? 2
                : 8
        )
        .padding(
            .bottom,
            model.positionType == .middle
                || model.positionType == .first
                ? 2
                : 8
        )
    }
}
