//
//  StickerMessageContentView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/03/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - StickerMessageContentView

struct StickerMessageContentView: View {
    var model: StickerMessageContentModel
    let action: ((ChatItemActionType) -> Void)?

    @State private var geometryProxy: GeometryProxy?
    
    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
    }

    private func buildContentView() -> some View {
        VStack(alignment: model.horizontalAlignment, spacing: 0) {
            buildMainView()
            buildReactionSummaryView()
        }
    }

    private func buildMainView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            buildStickerView()
            buildInfoView()
        }
        .background {
            GeometryReader { geometry in
                Spacer()
                    .onAppear {
                        geometryProxy = geometry
                    }
            }
        }
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
                .padding(.horizontal, 12)
        }
    }

    private func buildStickerView() -> some View {
        AnimatedImage(
            url: model.sticker,
            isAnimating: .constant(true)
        )
        .resizable()
        .indicator(.activity)
        .scaledToFit()
        .frame(width: 100, height: 100)
    }

    private func buildInfoView() -> some View {
        HStack(spacing: 0) {
            MessageCreatedDateTimeView(model: model.createdAt)
                .foregroundColor(ColorAssets.neutralRawDeepGrey.swiftUIColor)
            MessageStatusView(model: model.status)
                .foregroundColor(ColorAssets.neutralRawDeepGrey.swiftUIColor)
        }
    }
}
