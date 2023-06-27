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

    @State private var geometryProxy: GeometryProxy?

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
        VStack(alignment: model.horizontalAlignment, spacing: 0) {
            buildMainView()
            buildReactionSummaryView()
        }
    }

    private func buildMainView() -> some View {
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
            GeometryReader { geometry in
                MessageContentBackgroundView(
                    model: model.background
                )
                .onAppear {
                    geometryProxy = geometry
                }
            }
        )
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
                .foregroundColor(ColorAssets.neutralRawLightGrey.swiftUIColor)
            MessageStatusView(model: status)
                .foregroundColor(ColorAssets.neutralRawLightGrey.swiftUIColor)
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
                gradient: Gradient(colors: [.clear, ColorAssets.neutralRawDarkGrey.swiftUIColor]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
