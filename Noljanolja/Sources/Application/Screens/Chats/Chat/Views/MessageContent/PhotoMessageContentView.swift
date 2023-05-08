//
//  PhotoMessageContentView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 24/03/2023.
//

import Kingfisher
import SDWebImageSwiftUI
import SwiftUI

// MARK: - PhotoMessageContentView

struct PhotoMessageContentView: View {
    var model: PhotoMessageContentModel
    var action: ((ChatItemActionType) -> Void)?

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        VStack(spacing: 4) {
            ForEach(model.photoLists.indices, id: \.self) { row in
                HStack(spacing: 4) {
                    ForEach(model.photoLists[row].indices, id: \.self) { column in
                        buildItem(model.photoLists[row][column])
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildItem(_ url: URL?) -> some View {
        PhotoMessageContentItemView(
            url: url,
            createdAt: model.createdAt,
            seenByType: model.seenByType
        )
        .onTapGesture {
            action?(.openImageDetail(url))
        }
    }
}

// MARK: - PhotoMessageContentItemView

struct PhotoMessageContentItemView: View {
    var url: URL?
    let createdAt: Date
    let seenByType: SeenByType?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                buildImageView(size: geometry.size)
                buildInfoView()
            }
            .cornerRadius(12)
        }
        .aspectRatio(1, contentMode: .fill)
    }

    @ViewBuilder
    private func buildImageView(size: CGSize) -> some View {
        if let url {
            WebImage(
                url: url,
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(
                            width: size.width * 3,
                            height: size.height * 3
                        ),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .indicator(.activity)
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .clipped()
            .contentShape(Rectangle())
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
        } else {
            Spacer()
        }
    }

    private func buildInfoView() -> some View {
        HStack(spacing: 0) {
            Spacer()

            MessageCreatedDateTimeView(model: createdAt)
                .foregroundColor(ColorAssets.neutralLight.swiftUIColor)

            switch seenByType {
            case .single:
                MessageSeenByView(seenByType: seenByType)
            case .group, .unknown, .none:
                EmptyView()
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.clear, ColorAssets.neutralDarkGrey.swiftUIColor]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
