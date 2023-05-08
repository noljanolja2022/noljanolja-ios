//
//  TextMessageItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/03/2023.
//

import SwiftUI

// MARK: - TextMessageContentView

struct TextMessageContentView: View {
    var model: TextMessageContentModel
    var action: ((ChatItemActionType) -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(alignment: .bottom, spacing: 10) {
            buildContentView()
            buildInfoView()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    private func buildContentView() -> some View {
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
            
            switch model.seenByType {
            case .single:
                MessageSeenByView(seenByType: model.seenByType)
            case .group, .unknown, .none:
                EmptyView()
            }
        }
        .padding(.bottom, -2)
    }
}
