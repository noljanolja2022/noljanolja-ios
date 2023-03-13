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
        cornerRadius(18, corners: [.topRight, .bottomRight])
            .cornerRadius(position == .middle || position == .last ? 6 : 18, corners: [.topLeft])
            .cornerRadius(position == .middle || position == .first ? 6 : 18, corners: [.bottomLeft])
    }

    func senderMessageCornerRadius(_ position: ChatMessageItemModel.PositionType) -> some View {
        cornerRadius(18, corners: [.topLeft, .bottomLeft])
            .cornerRadius(position == .middle || position == .last ? 6 : 18, corners: [.topRight])
            .cornerRadius(position == .middle || position == .first ? 6 : 18, corners: [.bottomRight])
    }
}
