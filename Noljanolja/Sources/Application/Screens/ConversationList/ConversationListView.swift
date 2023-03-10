//
//  ConversationListView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import SwiftUI

// MARK: - ConversationListView

struct ConversationListView<ViewModel: ConversationListViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    init(viewModel: ViewModel = ConversationListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        buildBodyView()
            .onAppear { viewModel.send(.loadData) }
    }

    private func buildBodyView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            buildContentView()
                .statefull(
                    state: $viewModel.state.viewState,
                    isEmpty: { viewModel.state.conversations.isEmpty },
                    loading: buildLoadingView,
                    empty: buildEmptyView,
                    error: buildErrorView
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            buildNewChatView()
            
            buildNavigationLinkViews()
        }
    }

    private func buildContentView() -> some View {
        ListView {
            ForEach(viewModel.state.conversations, id: \.id) { conversation in
                ConversationItemView(model: conversation)
                    .background(Color.white)
                    .onTapGesture { viewModel.send(.openChat(conversation)) }
            }
        }
    }

    private func buildLoadingView() -> some View {
        LoadingView()
    }

    private func buildEmptyView() -> some View {
        Text("No conversations found")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildErrorView() -> some View {
        Text("Error")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildNewChatView() -> some View {
        NavigationLink(
            destination: {
                ContactListView(
                    viewModel: ContactListViewModel(
                        delegate: viewModel
                    )
                )
            },
            label: {
                HStack(spacing: 12) {
                    Image(systemName: "plus.message")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)

                    if viewModel.state.conversations.isEmpty {
                        Text("New Chat")
                            .font(.system(size: 16).bold())
                    }
                }
                .padding(12)
                .background(Color.green.opacity(0.5))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.3), radius: 8, y: 8)
            }
        )
        .foregroundColor(Color.black)
        .padding(16)
    }

    private func buildNavigationLinkViews() -> some View {
        NavigationLink(
            unwrapping: $viewModel.state.navigationLinkItem,
            onNavigate: { _ in },
            destination: { item in
                switch item.wrappedValue {
                case let .chat(conversation):
                    ChatView(
                        viewModel: ChatViewModel(
                            state: ChatViewModel.State(
                                conversation: conversation
                            )
                        )
                    )
                }
            },
            label: { EmptyView() }
        )
    }
}

// MARK: - ConversationListView_Previews

struct ConversationListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationListView()
    }
}
