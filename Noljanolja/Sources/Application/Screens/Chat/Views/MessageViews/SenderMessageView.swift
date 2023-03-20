//
//  SentMessageItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import SwiftUI

// MARK: - SenderMessageItemView

struct SenderMessageItemView: View {
    var messageItemModel: ChatMessageItemModel

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            Spacer(minLength: 32)
            
            Text(messageItemModel.date.string(withFormat: "HH:mm"))
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)

            MessageContentView(messageContent: messageItemModel.content)
                .senderMessageCornerRadius(messageItemModel.positionType)
            MessageStatusView(status: messageItemModel.status)
        }
        .padding(.horizontal, 16)
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

// MARK: - SenderMessageItemView_Previews

struct SenderMessageItemView_Previews: PreviewProvider {
    static var previews: some View {
        SenderMessageItemView(
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
