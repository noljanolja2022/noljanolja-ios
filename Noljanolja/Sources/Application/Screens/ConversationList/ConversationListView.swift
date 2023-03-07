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
        bodyView
            .onAppear { viewModel.send(.loadData) }
    }

    var bodyView: some View {
        ZStack(alignment: .bottomTrailing) {
            if viewModel.state.conversationModels.isEmpty {
                emptyView
            } else {
                contentView
            }

            newChatView
        }
    }

    var contentView: some View {
        List {
            ForEach(viewModel.state.conversationModels, id: \.id) { conversationModel in
                ConversationItemView(
                    avatar: conversationModel.avatar,
                    name: conversationModel.name,
                    lastMessage: conversationModel.lastMessage
                )
            }
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
    }

    var emptyView: some View {
        Text("No conversations found")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var newChatView: some View {
        NavigationLink(
            destination: {
                ContactListView()
            },
            label: {
                HStack(spacing: 12) {
                    Image(systemName: "plus.message")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)

                    if viewModel.state.conversationModels.isEmpty {
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
}

// MARK: - ConversationListView_Previews

struct ConversationListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationListView()
    }
}
