//
//  SentMessageItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import SwiftUI

// MARK: - SenderMessageItemView

struct SenderMessageItemView: View {
    var model: NormalMessageModel
    var action: ((ChatItemActionType) -> Void)?

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            Spacer(minLength: 60)

            switch model.seenByType {
            case .group:
                MessageSeenByView(seenByType: model.seenByType)
            case .single, .unknown, .none:
                EmptyView()
            }

            MessageContentView(
                model: model.content,
                action: action
            )
            .background(ColorAssets.primaryGreen50.swiftUIColor)
            .cornerRadius(12)
        }
        .padding(.trailing, 16)
        .padding(
            .top,
            { () -> CGFloat in
                switch model.positionType {
                case .all, .first: return 16
                case .middle, .last: return 4
                }
            }()
        )
    }
}
