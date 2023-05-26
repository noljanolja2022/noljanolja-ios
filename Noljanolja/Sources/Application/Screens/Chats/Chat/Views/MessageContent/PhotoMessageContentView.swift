//
//  PhotoMessageContentView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 24/03/2023.
//

import SDWebImageSwiftUI
import SwiftUI
import SwiftUIX

// MARK: - PhotoMessageContentView

struct PhotoMessageContentView: View {
    let model: PhotoMessageContentModel
    let action: ((ChatItemActionType) -> Void)?

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        HStack(spacing: 8) {
            buildShareView()
                .environment(\.layoutDirection, .leftToRight)
            buildContentView()
                .environment(\.layoutDirection, .leftToRight)
        }
        .padding(.leading, -36)
        .environment(\.layoutDirection, model.isSendByCurrentUser ? .leftToRight : .rightToLeft)
    }

    @ViewBuilder
    private func buildShareView() -> some View {
        Button(
            action: {},
            label: {
                ImageAssets.icShare.swiftUIImage
                    .padding(4)
                    .frame(width: 28, height: 28)
                    .background(ColorAssets.neutralGrey.swiftUIColor)
                    .cornerRadius(14)
            }
        )
        .visible(!model.isShareHidden)
    }

    private func buildContentView() -> some View {
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
        .padding(4)
        .background(
            MessageContentBackgroundView(
                model: model.background
            )
        )
    }

    private func buildItem(_ url: URL?) -> some View {
        PhotoMessageContentItemView(
            url: url,
            createdAt: model.createdAt,
            status: model.status
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
    let status: MessageStatusModel.StatusType

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        if let url {
            buildContentView(url: url)
        } else {
            Spacer()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func buildContentView(url: URL) -> some View {
        ZStack(alignment: .bottomTrailing) {
            buildImageView(url: url)
            buildInfoView()
        }
        .cornerRadius(10)
    }

    @ViewBuilder
    private func buildImageView(url: URL) -> some View {
        GeometryReader { geometry in
            WebImage(
                url: url,
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
            MessageCreatedDateTimeView(model: createdAt)
                .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
            MessageStatusView(model: status)
                .foregroundColor(ColorAssets.primaryGreen200.swiftUIColor)
        }
        .padding(.vertical, 8)
        .padding(
            .horizontal,
            {
                switch status {
                case .none, .sending, .sent: return 8
                case .seen: return 0
                }
            }()
        )
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.clear, ColorAssets.neutralDarkGrey.swiftUIColor]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
