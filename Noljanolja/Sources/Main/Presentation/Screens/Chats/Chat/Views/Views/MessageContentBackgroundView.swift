//
//  MessageContentBackgroundView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/05/2023.
//

import SwiftUI

struct MessageContentBackgroundView: View {
    let model: MessageContentBackgroundModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .rotation3DEffect(
                Angle(radians: model.rotationAngle),
                axis: .init(.vertical)
            )
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        switch model.type {
        case .bubble:
            buildBubbleView()
        case .cornerRadius:
            buildCornerRadius()
        }
    }

    private func buildBubbleView() -> some View {
        Image(
            image: ImageAssets.icChatBubble.image
                .resizableImage(
                    withCapInsets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 18),
                    resizingMode: .stretch
                )
                .withRenderingMode(.alwaysTemplate)
        )
        .foregroundColor(Color(model.color))
        .padding(.trailing, -6)
    }

    private func buildCornerRadius() -> some View {
        Color(model.color)
            .cornerRadius(12)
    }
}
