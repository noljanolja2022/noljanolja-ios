//
//  ChatView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/03/2023.
//
//

import SwiftUI

// MARK: - ChatView

struct ChatView<ViewModel: ChatViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        buildBodyView()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.state.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 0) {
            buildContentView()
                .statefull(
                    state: $viewModel.state.viewState,
                    isEmpty: { viewModel.state.chatItems.isEmpty },
                    loading: buildLoadingView,
                    empty: buildEmptyView,
                    error: buildErrorView
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    viewModel.send(.loadData)
                    viewModel.send(.isAppear(true))
                }
                .onDisappear {
                    viewModel.send(.isAppear(false))
                }
            ChatInputView(
                viewModel: ChatInputViewModel(
                    state: ChatInputViewModel.State(
                        conversationID: viewModel.state.conversationID
                    )
                )
            )
        }
    }

    private func buildContentView() -> some View {
        ListView {
            ForEach(Array(viewModel.state.chatItems.enumerated()), id: \.offset) { index, chatItem in
                ChatItemView(chatItem: chatItem)
                    .onAppear { viewModel.send(.loadMoreData(index)) }
            }
            .listRowInsets(EdgeInsets())
            .scaleEffect(x: 1, y: -1, anchor: .center)

            StatefullFooterView(
                state: $viewModel.state.footerViewState,
                errorView: ErrorFooterView(
                    action: {
                        viewModel.send(
                            .loadMoreData(
                                viewModel.state.chatItems.count - 1
                            )
                        )
                    }
                )
            )
            .scaleEffect(x: 1, y: -1, anchor: .center)
            .frame(height: 44)
        }
        .listStyle(PlainListStyle())
        .scaleEffect(x: 1, y: -1, anchor: .center)
    }

    private func buildLoadingView() -> some View {
        LoadingView()
    }

    private func buildEmptyView() -> some View {
        Text("Empty")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildErrorView() -> some View {
        Text("Error")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - ChatView_Previews

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(
            viewModel: ChatViewModel(
                state: ChatViewModel.State(
                    conversationID: 0
                )
            )
        )
    }
}
