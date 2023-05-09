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
    
    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            buildStickerView()
            buildInfoView()
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
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            SingleChatSeenView(isSeen: model.isSeen)
                .foregroundColor(ColorAssets.primaryGreen300.swiftUIColor)
        }
    }
}
