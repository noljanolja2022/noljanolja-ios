//
//  MessageItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import SwiftUI

// MARK: - NormalMessageView

struct NormalMessageView: View {
    var model: NormalMessageModel
    var action: ((ChatItemActionType) -> Void)?

    var body: some View {
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
