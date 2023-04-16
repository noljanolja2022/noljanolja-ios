//
//  SentMessageItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import SwiftUI

// MARK: - SenderMessageItemView

struct SenderMessageItemView: View {
    var model: MessageChatItemModel

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            Spacer(minLength: 32)
            
            Text(model.date.string(withFormat: "HH:mm"))
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)

            MessageContentView(messageContent: model.content)
                .senderMessageCornerRadius(model.positionType)
            MessageStatusView(status: model.status)
        }
        .padding(.horizontal, 16)
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
