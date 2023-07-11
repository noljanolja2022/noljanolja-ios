//
//  File.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/07/2023.
//

import Foundation
import SDWebImageSwiftUI
import SwiftUI

// MARK: - PhotoMessageContentItemView

struct PhotoMessageContentItemView: View {
    let model: PhotoMessageContentItemModel

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            buildImageView()
            buildOverlayView()
            buildInfoView()
        }
        .cornerRadius(10)
    }

    @ViewBuilder
    private func buildImageView() -> some View {
        GeometryReader { geometry in
            WebImage(
                url: model.url,
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(
                            width: geometry.size.width * 3,
                            height: geometry.size.height * 3
                        ),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .indicator(.activity)
            .scaledToFill()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
            .contentShape(Rectangle())
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
        }
        .aspectRatio(1, contentMode: .fill)
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
    
    @ViewBuilder
    private func buildOverlayView() -> some View {
        if let overlayText = model.overlayText, !overlayText.isEmpty {
            Text(overlayText)
                .font(.system(size: 36))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                .background(ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.5))
        }
    }
}
