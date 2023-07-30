//
//  MessageMetaDataView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/05/2023.
//

import SwifterSwift
import SwiftUI

// MARK: - MessageCreatedDateTimeView

struct MessageCreatedDateTimeView: View {
    let model: Date

    var body: some View {
        Text(model.string(withFormat: "HH:mm"))
            .dynamicFont(.systemFont(ofSize: 12))
    }
}

// MARK: - MessageStatusView

struct MessageStatusView: View {
    let model: MessageStatusModel.StatusType

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        switch model {
        case .none, .sending, .sent:
            EmptyView()
        case let .seen(seenType):
            MessageSeenView(model: seenType)
        }
    }
}

// MARK: - MessageSeenView

struct MessageSeenView: View {
    let model: MessageStatusModel.SeenType

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        switch model {
        case let .single(isSeen):
            if isSeen {
                ImageAssets.icChatSeen.swiftUIImage
                    .frame(width: 16, height: 16)
            }
        case let .group(count):
            if count > 0 {
                Text(String(count))
                    .dynamicFont(.systemFont(ofSize: 12, weight: .bold))
                    .foregroundColor(ColorAssets.primaryGreen300.swiftUIColor)
                    .padding(.bottom, 2)
            }
        case .none:
            EmptyView()
        }
    }
}
