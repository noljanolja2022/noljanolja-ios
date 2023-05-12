//
//  ChatView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/03/2023.
//
//

import Kingfisher
import SwiftUI
import SwiftUIX

// MARK: - ChatView

struct ChatView<ViewModel: ChatViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    func buildBodyView() -> some View {
        ZStack {
            buildMainView()
            buildNavigationLinks()
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.title)
                    .lineLimit(1)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isChatSettingEnabled {
                    Button(
                        action: {
                            viewModel.openChatSettingSubject.send()
                        },
                        label: {
                            ImageAssets.icMenu.swiftUIImage
                                .padding(10)
                                .frame(width: 44, height: 44)
                        }
                    )
                } else {
                    Spacer()
                        .frame(width: 44, height: 44)
                }
            }
        }
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
        .onReceive(viewModel.closeAction) {
            presentationMode.wrappedValue.dismiss()
        }
        .fullScreenCover(
            unwrapping: $viewModel.fullScreenCoverType,
            content: {
                buildFullScreenCoverDestinationView($0)
            }
        )
    }

    private func buildMainView() -> some View {
        VStack(spacing: 4) {
            buildContentView()
                .statefull(
                    state: $viewModel.viewState,
                    isEmpty: { viewModel.chatItems.isEmpty },
                    loading: buildLoadingView,
                    empty: buildEmptyView,
                    error: buildErrorView
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            ChatInputView(
                viewModel: ChatInputViewModel(
                    conversationID: viewModel.conversationID,
                    sendAction: viewModel.sendAction
                )
            )
        }
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildContentView() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(viewModel.chatItems.enumerated()), id: \.offset) { index, chatItem in
                    ChatItemView(
                        chatItem: chatItem,
                        action: {
                            viewModel.chatItemAction.send($0)
                        }
                    )
                    .onAppear { viewModel.loadMoreDataAction.send(index) }
                }
                .scaleEffect(x: 1, y: -1, anchor: .center)
            }
        }
        .scaleEffect(x: 1, y: -1, anchor: .center)
    }

    private func buildLoadingView() -> some View {
        LoadingView()
    }

    private func buildEmptyView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildErrorView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func buildNavigationLinks() -> some View {
        ZStack {
            NavigationLink(
                unwrapping: $viewModel.navigationType,
                onNavigate: { _ in },
                destination: {
                    switch $0.wrappedValue {
                    case let .chatSetting(conversation):
                        ChatSettingView(
                            viewModel: ChatSettingViewModel(
                                conversation: conversation,
                                delegate: viewModel
                            )
                        )
                    }
                },
                label: { EmptyView() }
            )
            .isDetailLink(false)
        }
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<ChatFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case let .openUrl(url):
            SafariView(url: url)
        case let .openImageDetail(url):
            NavigationView {
                ImageDetailView(
                    viewModel: ImageDetailViewModel(
                        imageUrl: url,
                        delegate: viewModel
                    )
                )
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
