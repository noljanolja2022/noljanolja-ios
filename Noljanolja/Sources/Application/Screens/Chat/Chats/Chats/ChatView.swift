//
//  ChatView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/03/2023.
//
//

import Kingfisher
import SwiftUI

// MARK: - ChatView

struct ChatView<ViewModel: ChatViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 0) {
            buildContentView()
                .statefull(
                    state: $viewModel.viewState,
                    isEmpty: { viewModel.chatItems.isEmpty },
                    loading: buildLoadingView,
                    empty: buildEmptyView,
                    error: buildErrorView
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    viewModel.isAppearSubject.send(true)
                    viewModel.loadLocalDataTrigger.send()
                }
                .onDisappear {
                    viewModel.isAppearSubject.send(false)
                }
            ChatInputView(
                viewModel: ChatInputViewModel(
                    conversationID: viewModel.conversationID
                )
            )
        }
    }

    private func buildContentView() -> some View {
        ListView {
            ForEach(Array(viewModel.chatItems.enumerated()), id: \.offset) { index, chatItem in
                ChatItemView(chatItem: chatItem)
                    .onAppear { viewModel.loadMoreDataTrigger.send(index) }
            }
            .listRowInsets(EdgeInsets())
            .scaleEffect(x: 1, y: -1, anchor: .center)
        }
        .scaleEffect(x: 1, y: -1, anchor: .center)
    }

    private func buildLoadingView() -> some View {
        LoadingView()
    }

    private func buildEmptyView() -> some View {
        Text("")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildErrorView() -> some View {
        Text("")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - ChatView_Previews

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(
            viewModel: ChatViewModel(
                conversationID: 0
            )
        )
    }
}
