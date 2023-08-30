//
//  ChatImagesView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/08/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - ChatImagesView

struct ChatImagesView<ViewModel: ChatAttachmentTabViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildMainView()
    }

    private func buildMainView() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                LazyVGrid(
                    columns: Array(repeating: .flexible(spacing: 4), count: 3),
                    spacing: 4
                ) {
                    ForEach(viewModel.models.indices, id: \.self) { index in
                        buildItem(viewModel.models[index])
                    }
                }
                .padding(.horizontal, 4)

                StatefullFooterView(
                    state: $viewModel.footerState,
                    errorView: EmptyView(),
                    noMoreDataView: EmptyView()
                )
                .onAppear {
                    viewModel.loadMoreAction.send()
                }
            }
        }
    }

    private func buildItem(_ model: ConversationAttachment) -> some View {
        GeometryReader { geometry in
            WebImage(
                url: model.getPhotoURL(conversationID: viewModel.conversation.id),
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
            .clipped()
        }
        .aspectRatio(1, contentMode: .fill)
        .frame(maxWidth: .infinity)
    }
}
