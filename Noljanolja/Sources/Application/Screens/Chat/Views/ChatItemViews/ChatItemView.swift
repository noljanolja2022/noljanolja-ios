//
//  ChatItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import SwiftUI

// MARK: - ChatItemView

struct ChatItemView: View {
    var chatItem: ChatItemModelType

    var body: some View {
        switch chatItem {
        case let .date(dateItemModel):
            ChatDateItemView(dateItemModel: dateItemModel)
        case let .item(messageItemModel):
            ChatMessageItemView(messageItemModel: messageItemModel)
        }
    }
}

// MARK: - ChatItemView_Previews

struct ChatItemView_Previews: PreviewProvider {
    static var previews: some View {
        ChatItemView(
            chatItem: .item(
                ChatMessageItemModel(
                    id: 0,
                    isSenderMessage: true,
                    avatar: "https://sm.ign.com/ign_nordic/cover/a/avatar-gen/avatar-generations_prsz.jpg",
                    date: Date(),
                    content: .plaintext(
                        TextMessageContentModel(
                            isSenderMessage: true,
                            message: "Test message"
                        )
                    ),
                    status: .received
                )
            )
        )
    }
}
