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
            .navigationBarTitle(viewModel.state.conversation.id.string)
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
                .onAppear { viewModel.send(.loadData) }
            ChatInputView(
                viewModel: ChatInputViewModel(
                    state: ChatInputViewModel.State(conversation: viewModel.state.conversation)
                )
            )
        }
    }

    private func buildContentView() -> some View {
        ListView {
            ForEach(viewModel.state.chatItems, id: \.id) { chatItem in
                ChatItemView(chatItem: chatItem)
            }
            .listRowInsets(EdgeInsets())
            .scaleEffect(x: 1, y: -1, anchor: .center)
        }
        .listStyle(PlainListStyle())
        .scaleEffect(x: 1, y: -1, anchor: .center)
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
}

// MARK: - ChatView_Previews

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(
            viewModel: ChatViewModel(
                state: ChatViewModel.State(
                    conversation: Conversation(
                        id: 0,
                        title: "title",
                        creator: User(
                            id: "id",
                            name: "name",
                            avatar: "avatar",
                            phone: "1234567890",
                            email: "email@gmail.com",
                            isEmailVerified: false,
                            pushToken: "pushToken",
                            dob: "dob",
                            gender: "Male"
                        ),
                        type: .single,
                        messages: [],
                        participants: [],
                        createdAt: Date(),
                        updatedAt: Date()
                    )
                )
            )
        )
    }
}
