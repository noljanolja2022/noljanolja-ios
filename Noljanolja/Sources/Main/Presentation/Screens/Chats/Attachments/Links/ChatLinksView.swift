//
//  ChatLinksView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/08/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - ChatLinksView

struct ChatLinksView<ViewModel: ChatAttachmentTabViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildMainView()
    }

    private func buildMainView() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                VStack(spacing: 12) {
                    ForEach(viewModel.models.indices, id: \.self) { index in
                        buildItem(viewModel.models[index])
                    }
                }
                .padding(.horizontal, 12)

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
        HStack(alignment: .center, spacing: 12) {
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
                .placeholder(content: {
                    ImageAssets.icLink.swiftUIImage
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        .padding(4)
                })
                .indicator(.activity)
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .clipped()
            }
            .aspectRatio(1, contentMode: .fill)
            .frame(width: 72)
            .cornerRadius(8)

            VStack(spacing: 4) {
                Text(model.name)
                    .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                Text(Date().string(withFormat: "EEEE, dd MMMM, yyyy"))
                    .dynamicFont(.systemFont(ofSize: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            }
        }
    }
}
