//
//  SentMessageView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import SwiftUI

// MARK: - SenderMessageView

struct SenderMessageView: View {
    var messageItemModel: MessageItemModel

    var body: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 120)
            MessageContentView(messageContent: messageItemModel.content)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 16)
    }
}

// MARK: - SenderMessageView_Previews

struct SenderMessageView_Previews: PreviewProvider {
    static var previews: some View {
        SenderMessageView(
            messageItemModel: MessageItemModel(
                id: 0,
                isSenderMessage: true,
                avatar: "https://sm.ign.com/ign_nordic/cover/a/avatar-gen/avatar-generations_prsz.jpg",
                date: "06:00",
                content: .plaintext(PlaintextMessageContentItemModel(
                    isSenderMessage: true,
                    message: "Hello, world"
                ))
            )
        )
    }
}
