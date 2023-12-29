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
        buildMainView()
            .clipped()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
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

    private func buildMainView() -> some View {
        VideoDetailRootContainerView(
            content: {
                ZStack(alignment: .bottomTrailing) {
                    buildContentStatefullView()
                    buildNavigationLink()
                }
            },
            viewModel: VideoDetailRootContainerViewModel()
        )
    }

    private func buildContentStatefullView() -> some View {
        buildContentView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.conversations.isEmpty },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildContentView() -> some View {
        VStack {
            buildHeaderView()
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
    }

    private func buildHeaderView() -> some View {
        HStack(spacing: 12) {
            Button(
                action: {},
                label: {
                    ImageAssets.icMenu.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .height(24)
                }
            )

            HStack {
                Text(L10n.commonSearchFriend)
                    .dynamicFont(.systemFont(ofSize: 14))
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                Spacer()
                ImageAssets.icSearch.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .height(24)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .height(36)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
            .cornerRadius(5)
            .onTapGesture {}

            AvatarView(url: viewModel.avatarURL, size: .init(width: 24, height: 24))
                .onTapGesture {
                    viewModel.navigationType = .setting
                }
        }
        .padding(.horizontal, 10)
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
                case .setting:
                    ProfileSettingView(
                        viewModel: ProfileSettingViewModel(
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
