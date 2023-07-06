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
    let action: ((PhotoMessageContentModel.ActionType) -> Void)?

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
        VStack(
            alignment: model.reactionsModel?.horizontalAlignment ?? .center,
            spacing: 0
        ) {
            buildMainView()
            buildReactionView()
        }
    }

    private func buildMainView() -> some View {
        ZStack {
            if model.photos.count < 4 {
                buildSingleRowImagesView()
            } else {
                buildMultiRowImagesView()
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
            action?(.openMessageActionDetail(geometryProxy))
        }
    }
    
    private func buildSingleRowImagesView() -> some View {
        HStack(spacing: 4) {
            ForEach(model.photos.indices, id: \.self) { index in
                buildItem(
                    url: model.photos[index]
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func buildMultiRowImagesView() -> some View {
        let photoLists = model.photos
            .reduce([[URL?]]()) { result, url in
                var result = result
                if let lastURLs = result.last, lastURLs.count < 2 {
                    result[result.count - 1].append(url)
                } else {
                    result.append([url])
                }
                return result
            }
            .prefix(2)
        VStack(spacing: 4) {
            ForEach(photoLists.indices, id: \.self) { row in
                HStack(spacing: 4) {
                    ForEach(photoLists[row].indices, id: \.self) { column in
                        let totalCount = model.photos.count
                        let displayCount = photoLists.reduce(0) { $0 + $1.count }
                        let currentIndex = row * 2 + column
                        let remainCount = totalCount - displayCount
                        let overlayText: String? = {
                            if currentIndex == displayCount - 1, remainCount > 0 {
                                return "+\(remainCount)"
                            } else {
                                return nil
                            }
                        }()
                        buildItem(
                            url: photoLists[row][column],
                            overlayText: overlayText
                        )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildReactionView() -> some View {
        MessageReactionsView(
            model: model.reactionsModel,
            quickTapAction: {
                action?(.reaction($0))
            },
            quickLongPressAction: {
                action?(.openMessageQuickReactionDetail($0))
            }
        )
        .padding(.top, -12)
    }

    @ViewBuilder
    private func buildItem(url: URL?, overlayText: String? = nil) -> some View {
        let model = PhotoMessageContentItemModel(
            url: url,
            overlayText: overlayText,
            createdAt: model.createdAt,
            status: model.status
        )
        PhotoMessageContentItemView(model: model)
            .onTapGesture {
                action?(.openImages)
            }
    }
}
