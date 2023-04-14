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

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        ZStack {
            buildBodyView()
            buildNavigationLinks()
        }
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
        .onReceive(viewModel.closeAction) {
            presentationMode.wrappedValue.dismiss()
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
                .onAppear { viewModel.isAppearSubject.send(true) }
                .onDisappear { viewModel.isAppearSubject.send(false) }
            ChatInputView(
                viewModel: ChatInputViewModel(
                    conversationID: viewModel.conversationID
                )
            )
        }
    }

    private func buildContentView() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(viewModel.chatItems.enumerated()), id: \.offset) { index, chatItem in
                    ChatItemView(chatItem: chatItem)
                        .onAppear { viewModel.loadMoreDataTrigger.send(index) }
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
        Text("")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildErrorView() -> some View {
        Text("")
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
