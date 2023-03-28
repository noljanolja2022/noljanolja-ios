//
//  ReceiverMessageItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Kingfisher
import SDWebImageSwiftUI
import SwiftUI

// MARK: - ReceiverMessageItemView

struct ReceiverMessageItemView: View {
    var messageItemModel: ChatMessageItemModel

    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            if messageItemModel.positionType == .all
                || messageItemModel.positionType == .first {
                WebImage(url: URL(string: messageItemModel.avatar ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .background(ColorAssets.neutralGrey.swiftUIColor)
                    .cornerRadius(12)
            }

            HStack(alignment: .bottom, spacing: 4) {
                MessageContentView(messageContent: messageItemModel.content)
                    .receiverMessageCornerRadius(messageItemModel.positionType)

                Text(messageItemModel.date.string(withFormat: "HH:mm"))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
            }
            .padding(
                .top,
                messageItemModel.positionType == .all
                    || messageItemModel.positionType == .first
                    ? 16
                    : 0
            )

            Spacer(minLength: 32)
        }
        .padding(
            .leading,
            messageItemModel.positionType == .all
                || messageItemModel.positionType == .first
                ? 16
                : 52
        )
        .padding(.trailing, 16)
        .padding(
            .top,
            messageItemModel.positionType == .middle
                || messageItemModel.positionType == .last
                ? 2
                : 8
        )
        .padding(
            .bottom,
            messageItemModel.positionType == .middle
                || messageItemModel.positionType == .first
                ? 2
                : 8
        )
    }
}

// MARK: - ReceiverMessageItemView_Previews

struct ReceiverMessageItemView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiverMessageItemView(
            messageItemModel: ChatMessageItemModel(
                id: 0,
                isSenderMessage: true,
                avatar: "https://sm.ign.com/ign_nordic/cover/a/avatar-gen/avatar-generations_prsz.jpg",
                date: Date(),
                content: .plaintext(TextMessageContentModel(
                    isSenderMessage: true,
                    message: "Hello, world"
                )),
                status: .received
            )
        )
    }
}
