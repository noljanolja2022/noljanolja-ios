//
//  MessageChatItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/05/2023.
//

import SwiftUI

struct MessageChatItemView: View {
    let model: MessageChatItemModel
    let action: ((NormalMessageModel.ActionType) -> Void)?

    var body: some View {
        switch model {
        case let .normal(model):
            NormalMessageView(
                model: model,
                action: action
            )
        case let .event(model):
            EventMessageView(
                model: model
            )
        }
    }
}
