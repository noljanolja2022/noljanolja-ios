//
//  MessageView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import SwiftUI

// MARK: - MessageView

struct MessageView: View {
    var messageItemModel: MessageItemModel

    var body: some View {
        if messageItemModel.isSenderMessage {
            SenderMessageView(messageItemModel: messageItemModel)
        } else {
            ReceiverMessageView(messageItemModel: messageItemModel)
        }
    }
}

// MARK: - MessageView_Previews

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(
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
