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

    @StateObject var viewModel: ViewModel
    @Binding var isCreateChatShown: Bool
    @Binding var createConversationType: ConversationType?

    // MARK: State

    var body: some View {
        buildBodyView()
            .onAppear { viewModel.send(.loadData) }
            .clipped()
    }

    private func buildBodyView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                ZStack {
                    SearchView(
                        placeholder: "Search friend...",
                        text: .constant(""),
                        isUserInteractionEnabled: false
                    )
                    .padding(.horizontal, 16)

                    Button(
                        action: { isCreateChatShown = true },
                        label: {
                            Text("")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    )
                }
                .frame(height: 36)

                buildContentView()
                    .padding(.top, 12)
                    .statefull(
                        state: $viewModel.state.viewState,
                        isEmpty: { viewModel.state.conversations.isEmpty },
                        loading: buildLoadingView,
                        empty: buildEmptyView,
                        error: buildErrorView
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.top, 12)
            
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
        ZStack {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    ZStack {}
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    ImageAssets.icAppMascot.swiftUIImage
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height / 2)
                        .offset(y: 100)
                }
            }
            .clipped()

            VStack(spacing: 10) {
                Text("Select contact to chat now")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)

                Button(
                    action: { isCreateChatShown = true },
                    label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text("New chat")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                    }
                )
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .background(ColorAssets.primaryYellowMain.swiftUIColor)
                .cornerRadius(10)
            }
        }
    }

    private func buildErrorView() -> some View {
        Text("Error")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildNavigationLinkViews() -> some View {
        ZStack {
            NavigationLink(
                unwrapping: $createConversationType,
                onNavigate: { _ in },
                destination: { createConversationType in
                    ContactListView(
                        viewModel: ContactListViewModel(
                            delegate: viewModel
                        ),
                        createConversationType: createConversationType.wrappedValue
                    )
                },
                label: { EmptyView() }
            )

            NavigationLink(
                unwrapping: $viewModel.state.navigationLinkItem,
                onNavigate: { _ in },
                destination: { item in
                    switch item.wrappedValue {
                    case let .chat(conversation):
                        ChatView(
                            viewModel: ChatViewModel(
                                conversationID: conversation.id
                            )
                        )
                    }
                },
                label: { EmptyView() }
            )
        }
    }
}

// MARK: - ConversationListView_Previews

struct ConversationListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationListView(
            viewModel: ConversationListViewModel(),
            isCreateChatShown: .constant(false),
            createConversationType: .constant(.single)
        )
    }
}
