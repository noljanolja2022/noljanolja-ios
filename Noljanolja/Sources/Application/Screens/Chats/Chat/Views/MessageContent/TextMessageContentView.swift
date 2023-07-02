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

    @State private var geometryProxy: GeometryProxy?

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
        VStack(alignment: model.horizontalAlignment, spacing: 0) {
            buildMainView()
            buildReactionSummaryView()
        }
    }

    private func buildMainView() -> some View {
        HStack(alignment: .bottom, spacing: 10) {
            buildTextView()
            buildInfoView()
        }
        .padding(12)
        .background(
            GeometryReader { geometry in
                MessageContentBackgroundView(
                    model: model.background
                )
                .onAppear {
                    geometryProxy = geometry
                }
            }
        )
        .onTapGesture {}
        .onLongPressGesture {
            action?(.reaction(geometryProxy, model.message))
        }
    }

    @ViewBuilder
    private func buildReactionSummaryView() -> some View {
        if let reactionSummaryModel = model.reactionSummaryModel {
            MessageReactionSummaryView(model: reactionSummaryModel)
                .frame(height: 20)
                .padding(.vertical, 2)
                .padding(.horizontal, 6)
                .background(Color(model.background.color))
                .cornerRadius(10)
                .border(ColorAssets.neutralLight.swiftUIColor, width: 2, cornerRadius: 10)
                .padding(.top, -10)
                .padding(.horizontal, 12)
        }
    }

    private func buildTextView() -> some View {
        ZStack {
            Text(model.messageString)
                .font(.system(size: 16, weight: .regular))
                .background(.clear)
                .foregroundColor(.clear)

            DataDetectorTextView(
                text: .constant(model.messageString),
                dataAction: {
                    action?(.openURL($0))
                }
            )
            .font(.system(size: 16, weight: .regular))
            .dataDetectorTypes(.link)
            .isEditable(false)
            .isScrollEnabled(false)
            .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
        }
    }

    private func buildInfoView() -> some View {
        HStack(spacing: 0) {
            MessageCreatedDateTimeView(model: model.createdAt)
                .foregroundColor(ColorAssets.neutralRawDeepGrey.swiftUIColor)
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