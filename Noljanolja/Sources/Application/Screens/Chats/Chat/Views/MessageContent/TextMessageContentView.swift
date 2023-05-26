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
        HStack(alignment: .bottom, spacing: 4) {
            buildGroupChatStatusView()
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
        .background(
            MessageContentBackgroundView(
                model: model.background
            )
        )
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
            buildSingleChatStatusView()
        }
        .padding(.bottom, -2)
    }

    @ViewBuilder
    private func buildGroupChatStatusView() -> some View {
        switch model.status {
        case let .seen(seenType):
            switch seenType {
            case .group:
                MessageStatusView(model: model.status)
            case .single, .none:
                EmptyView()
            }
        case .none, .sending, .sent:
            EmptyView()
        }
    }

    @ViewBuilder
    private func buildSingleChatStatusView() -> some View {
        switch model.status {
        case let .seen(seenType):
            switch seenType {
            case .single:
                MessageStatusView(model: model.status)
            case .group, .none:
                EmptyView()
            }
        case .none, .sending, .sent:
            EmptyView()
        }
    }
}
