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
    let action: ((StickerMessageContentModel.ActionType) -> Void)?

    @State private var geometryProxy: GeometryProxy?
    
    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            buildForwardView()
            buildContentView()
        }
    }

    @ViewBuilder
    private func buildForwardView() -> some View {
        if model.isForward {
            ForwardView()
        }
    }

    private func buildContentView() -> some View {
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
        .padding(.bottom, 10)
        .onTapGesture {}
        .onLongPressGesture {
            action?(.openMessageActionDetail(geometryProxy))
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
