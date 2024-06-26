//
//  ChatItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import SwiftUI

// MARK: - ChatItemView

struct ChatItemView: View {
    let chatItem: ChatItemModelType
    let action: ((NormalMessageModel.ActionType) -> Void)?

    var body: some View {
        switch chatItem {
        case let .date(model):
            DateChatItemView(model: model)
        case let .message(model):
            MessageChatItemView(
                model: model,
                action: action
            )
        }
    }
}
