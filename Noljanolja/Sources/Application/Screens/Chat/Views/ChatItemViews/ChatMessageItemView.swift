//
//  MessageItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import SwiftUI

// MARK: - ChatMessageItemView

struct ChatMessageItemView: View {
    var messageItemModel: ChatMessageItemModel

    var body: some View {
        if messageItemModel.content == nil {
            EmptyView()
        } else {
            if messageItemModel.isSenderMessage {
                SenderMessageItemView(messageItemModel: messageItemModel)
            } else {
                ReceiverMessageItemView(messageItemModel: messageItemModel)
            }
        }
    }
}

// MARK: - ChatMessageItemView_Previews

struct ChatMessageItemView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageItemView(
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
