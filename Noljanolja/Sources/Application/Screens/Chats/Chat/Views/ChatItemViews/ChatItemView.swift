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
        case let .date(model):
            ChatDateItemView(model: model)
        case let .item(model):
            ChatMessageItemView(model: model)
        case let .event(model):
            ChatEventItemView(model: model)
        }
    }
}
