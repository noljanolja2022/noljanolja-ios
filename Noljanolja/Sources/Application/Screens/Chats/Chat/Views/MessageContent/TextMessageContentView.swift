//
//  TextMessageItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/03/2023.
//

import SwiftUI

// MARK: - TextMessageContentView

struct TextMessageContentView: View {
    let model: TextMessageContentModel
    let action: ((ChatItemActionType) -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(spacing: 8) {
            buildGroupSeenBy()
            buildContentView()
        }
    }

    private func buildContentView() -> some View {
        HStack(alignment: .bottom, spacing: 10) {
            buildTextView()
            buildInfoView()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(model.backgroundColor))
        .cornerRadius(12)
    }

    private func buildTextView() -> some View {
        ZStack {
            Text(model.message)
                .font(.system(size: 16, weight: .regular))
                .background(.clear)
                .foregroundColor(.clear)

            DataDetectorTextView(
                text: .constant(model.message),
                dataAction: {
                    action?(.openURL($0))
                }
            )
            .font(.system(size: 16, weight: .regular))
            .dataDetectorTypes(.link)
            .isEditable(false)
            .isScrollEnabled(false)
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
    }

    private func buildInfoView() -> some View {
        HStack(spacing: 0) {
            MessageCreatedDateTimeView(model: model.createdAt)
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            buildSingleSeenBy()
        }
        .padding(.bottom, -2)
    }

    @ViewBuilder
    private func buildGroupSeenBy() -> some View {
        switch model.seenByType {
        case let .group(count):
            GroupChatSeenView(count: count)
        case .single, .unknown, .none:
            EmptyView()
        }
    }

    @ViewBuilder
    private func buildSingleSeenBy() -> some View {
        switch model.seenByType {
        case let .single(isSeen):
            SingleChatSeenView(isSeen: isSeen)
                .foregroundColor(ColorAssets.primaryGreen300.swiftUIColor)
        case .group, .unknown, .none:
            EmptyView()
        }
    }
}
