//
//  ConversationListView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import Combine
import SwiftUI
import SwiftUIX

// MARK: - ConversationListView

struct ConversationListView<ViewModel: ConversationListViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    let toolBarAction: AnyPublisher<MainToolBarActionType?, Never>

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            buildContentView()
            buildNavigationLink()
        }
        .clipped()
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
        .isProgressHUBVisible($viewModel.isProgressHUDShowing)
        .onReceive(toolBarAction) {
            switch $0 {
            case .createConversation:
                withoutAnimation {
                    viewModel.fullScreenCoverType = .createConversation
                }
            case .none:
                break
            }
        }
        .fullScreenCover(
            unwrapping: $viewModel.fullScreenCoverType,
            onDismiss: {
                viewModel.isPresentingSubject.send(false)
            },
            content: {
                buildFullScreenCoverDestinationView($0)
            }
        )
    }

    private func buildContentView() -> some View {
        buildListView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.conversations.isEmpty },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.conversations, id: \.id) { conversation in
                    ConversationItemView(model: conversation)
                        .onTapGesture {
                            viewModel.openChatAction.send(conversation)
                        }
                }
            }
        }
    }

    private func buildNavigationLink() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: { item in
                switch item.wrappedValue {
                case let .chat(conversation):
                    ChatView(
                        viewModel: ChatViewModel(
                            conversationID: conversation.id,
                            delegate: viewModel
                        )
                    )
                case let .contactList(conversationType):
                    CreateConversationContactListView(
                        viewModel: CreateConversationContactListViewModel(
                            createConversationType: conversationType,
                            delegate: viewModel
                        )
                    )
                }
            },
            label: {
                EmptyView()
            }
        )
        .isDetailLink(false)
    }
}

extension ConversationListView {
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildEmptyView() -> some View {
        EmptyView()
    }

    private func buildErrorView() -> some View {
        Text(L10n.commonErrorTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }
}

extension ConversationListView {
    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<ConversationListFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case .createConversation:
            NavigationView {
                CreateConversationView(
                    viewModel: CreateConversationViewModel(
                        delegate: viewModel
                    )
                )
                .introspectViewController {
                    $0.view.backgroundColor = .clear
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            .introspectNavigationController { navigationController in
                navigationController.configure(
                    backgroundColor: ColorAssets.neutralLight.color,
                    foregroundColor: ColorAssets.neutralDarkGrey.color
                )
                navigationController.view.backgroundColor = .clear
                navigationController.parent?.view.backgroundColor = .clear
            }
        }
    }
}

// MARK: - ConversationListView_Previews

struct ConversationListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationListView(
            viewModel: ConversationListViewModel(),
            toolBarAction: Just<MainToolBarActionType?>(nil).eraseToAnyPublisher()
        )
    }
}
