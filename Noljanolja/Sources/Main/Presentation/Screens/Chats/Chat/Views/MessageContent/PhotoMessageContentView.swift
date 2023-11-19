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
//    let reactionIcons: [ReactIcon]

    @State private var geometryProxy: GeometryProxy?
    @State private var isShowedContextMenu = false

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        HStack(spacing: 8) {
//            buildShareView()
            buildContentView()
        }
        //        .padding(.leading, -36)
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
                    .background(ColorAssets.neutralRawLightGrey.swiftUIColor)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    .cornerRadius(14)
            }
        )
        .visible(!model.isShareHidden)
    }

    private func buildContentView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            buildForwardView()
            buildMainView()
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

//    private func buildReactionIconsView() -> some View {
//        HStack(spacing: 4) {
//            ForEach(reactionIcons.indices, id: \.self) { index in
//                let model = reactionIcons[index]
//                Button(
//                    action: {
    ////                        viewModel.reactionAction.send(model)
//                    },
//                    label: {
//                        Text(model.code ?? "")
//                            .dynamicFont(.systemFont(ofSize: 16))
//                    }
//                )
//            }
//        }
//        .padding(.horizontal, 8)
//        .frame(height: 32)
//        .background(ColorAssets.neutralLight.swiftUIColor)
//        .cornerRadius(8)
//    }
//
//    private func buildActionsView() -> some View {
//        HStack(spacing: 4) {
//            ForEach(viewModel.messageActionTypes, id: \.self) { model in
//                Button(
//                    action: {
//                        viewModel.action.send(model)
//                    },
//                    label: {
//                        VStack(spacing: 8) {
//                            Image(model.imageName)
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                                .foregroundColor(ColorAssets.primaryGreen200.swiftUIColor)
//                            Text(model.title)
//                                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
//                                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
//                        }
//                        .padding(12)
//                    }
//                )
//            }
//        }
//        .background(ColorAssets.neutralLight.swiftUIColor)
//        .cornerRadius(4)
//    }

    @ViewBuilder
    private func buildForwardView() -> some View {
        if model.isForward {
            ForwardView()
        }
    }

    @ViewBuilder
    private func buildMainView() -> some View {
        if model.photos.count < 4 {
            buildSingleRowImagesView()
        } else {
            buildMultiRowImagesView()
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
