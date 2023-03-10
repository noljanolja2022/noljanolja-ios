//
//  MessageContentView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import SwiftUI

// MARK: - MessageContentView

struct MessageContentView: View {
    var messageContent: MessageItemModel.ContentType

    var body: some View {
        switch messageContent {
        case let .plaintext(model):
            return TextMessageContentView(contentItemModel: model)
        }
    }
}

// MARK: - MessageContentView_Previews

struct MessageContentView_Previews: PreviewProvider {
    static var previews: some View {
        MessageContentView(
            messageContent: .plaintext(PlaintextMessageContentItemModel(
                isSenderMessage: true,
                message: "Hello, world"
            ))
        )
    }
}
