//
//  MessageItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import SwiftUI

// MARK: - ChatMessageItemView

struct ChatMessageItemView: View {
    var model: ChatMessageItemModel
    var action: ((ChatItemActionType) -> Void)?

    var body: some View {
        if model.content == nil {
            EmptyView()
        } else {
            if model.isSenderMessage {
                SenderMessageItemView(
                    model: model,
                    action: action
                )
            } else {
                ReceiverMessageView(
                    model: model,
                    action: action
                )
            }
        }
    }
}
