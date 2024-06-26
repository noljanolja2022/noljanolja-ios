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
    let action: ((TextMessageContentModel.ActionType) -> Void)?

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
        VStack(alignment: .leading, spacing: 4) {
            buildForwardView()
            HStack(alignment: .bottom, spacing: 10) {
                buildTextView()
                buildInfoView()
            }
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
            action?(.openMessageActionDetail(geometryProxy))
        }
    }

    @ViewBuilder
    private func buildForwardView() -> some View {
        if model.isForward {
            ForwardView()
        }
    }

    private func buildTextView() -> some View {
        ZStack {
            Text(model.messageString)
                .dynamicFont(.systemFont(ofSize: 16))
                .background(.clear)
                .foregroundColor(.clear)

            DataDetectorTextView(
                text: .constant(model.messageString),
                dataAction: {
                    action?(.openURL($0))
                }
            )
            .dynamicFont(.systemFont(ofSize: 16), isDynamicFontEnabled: true)
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
