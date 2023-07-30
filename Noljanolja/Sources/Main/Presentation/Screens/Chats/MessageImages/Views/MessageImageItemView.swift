//
//  MessageImageItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/07/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - PhotoMessageContentItemView

struct MessageImageItemView: View {
    let model: PhotoMessageContentItemModel

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            buildImageView()
            buildInfoView()
        }
    }

    @ViewBuilder
    private func buildImageView() -> some View {
        WebImage(
            url: model.url
        )
        .resizable()
        .indicator(.activity)
        .scaledToFit()
        .frame(maxWidth: .infinity)
        .background(ColorAssets.neutralLightGrey.swiftUIColor)
    }

    private func buildInfoView() -> some View {
        HStack(spacing: 0) {
            Spacer()
            MessageCreatedDateTimeView(model: model.createdAt)
                .foregroundColor(ColorAssets.neutralRawLightGrey.swiftUIColor)
            MessageStatusView(model: model.status)
                .foregroundColor(ColorAssets.neutralRawLightGrey.swiftUIColor)
        }
        .padding(.vertical, 8)
        .padding(
            .horizontal,
            {
                switch model.status {
                case .none, .sending, .sent: return 8
                case .seen: return 0
                }
            }()
        )
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.clear, ColorAssets.neutralRawDarkGrey.swiftUIColor]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
