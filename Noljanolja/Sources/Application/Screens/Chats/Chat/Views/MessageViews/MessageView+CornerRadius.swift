//
//  MessageView+CornerRadius.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import Foundation
import SwiftUI

extension View {
    func receiverMessageCornerRadius(_ position: ChatMessageItemModel.PositionType) -> some View {
        cornerRadius([.topTrailing, .bottomTrailing], 18)
            .cornerRadius([.topLeading], position == .middle || position == .last ? 6 : 18)
            .cornerRadius([.bottomLeading], position == .middle || position == .first ? 6 : 18)
    }

    func senderMessageCornerRadius(_ position: ChatMessageItemModel.PositionType) -> some View {
        cornerRadius([.topLeading, .bottomLeading], 18)
            .cornerRadius([.topTrailing], position == .middle || position == .last ? 6 : 18)
            .cornerRadius([.bottomTrailing], position == .middle || position == .first ? 6 : 18)
    }
}
