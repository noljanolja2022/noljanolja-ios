//
//  MessageReactionSummaryView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/06/2023.
//

import SwiftUI

struct MessageReactionSummaryView: View {
    var model: MessageReactionSummaryModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(spacing: 4) {
            HStack(spacing: 0) {
                ForEach(model.reactIcons.indices, id: \.self) { index in
                    let model = model.reactIcons[index]
                    Text(model.code ?? "")
                        .font(.system(size: 12))
                }
            }
            Text(String(model.count))
                .font(.system(size: 12))
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
    }
}
