//
//  ChatView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/03/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - ChatView

struct ChatView<ViewModel: ChatViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode
    @State var scrollOffset = CGFloat.zero

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
                        }
                    )
                } else {
                    Spacer()
                }
            }
        }
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
        .onReceive(viewModel.closeAction) {
            presentationMode.wrappedValue.dismiss()
        }
        .onChange(of: viewModel.fullScreenCoverType) { fullScreenCoverType in
            guard let fullScreenCoverType else { return }
            UIView.setAnimationsEnabled(fullScreenCoverType.isAnimationsEnabled)
        }
        .fullScreenCover(
            unwrapping: $viewModel.fullScreenCoverType,
            content: {
                buildFullScreenCoverDestinationView($0)
            }
        )
    }

    private func buildMainView() -> some View {
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
            ChatInputView(
                viewModel: ChatInputViewModel(
                    conversationID: viewModel.conversationID,
                    sendAction: viewModel.sendAction,
                    delegate: viewModel
                )
            )
        }
        .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildContentView() -> some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottomTrailing) {
                buildChatView()
                buildQuickScrollDownView(proxy)
            }
            .onReceive(viewModel.scrollToChatItemAction) { index, anchor in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo("\(ChatItemModelType.viewIdPrefix)_\(index)", anchor: anchor)
                }
            }
        }
    }

    @ViewBuilder
    private func buildQuickScrollDownView(_: ScrollViewProxy) -> some View {
        Button(
            action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.scrollToChatItemAction.send((0, .top))
                }
            },
            label: {
                ImageAssets.icArrowRight.swiftUIImage
                    .resizable()
                    .rotationEffect(.pi / 2)
                    .padding(4)
                    .frame(width: 20, height: 20)
                    .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                    .background(ColorAssets.primaryGreen200.swiftUIColor)
                    .cornerRadius(10)
                    .padding(.vertical, 8)
                    .padding(.leading, 8)
                    .padding(.trailing, 20)
                    .background(ColorAssets.neutralLight.swiftUIColor)
                    .cornerRadius([.topLeading, .bottomLeading], 4)
                    .overlayBorder(color: ColorAssets.primaryGreen200.swiftUIColor, cornerRadius: 4, lineWidth: 1)
                    .padding(.trailing, -4)
                    .shadow(
                        color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.25),
                        radius: 4
                    )
            }
        )
        .padding(.bottom, 32)
        .hidden(scrollOffset < UIScreen.main.bounds.height / 2)
    }

    private func buildChatView() -> some View {
        ChatScrollView(scrollOffset: $scrollOffset) {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.chatItems.indices, id: \.self) { index in
                    let model = viewModel.chatItems[index]
                    ChatItemView(
                        chatItem: model,
                        action: {
                            viewModel.chatItemAction.send((model, $0))
                        }
                    )
                    .onAppear { viewModel.loadMoreDataAction.send(index) }
                    .id("\(ChatItemModelType.viewIdPrefix)_\(index)")
                }
                .scaleEffect(x: 1, y: -1, anchor: .center)
            }
            .padding(.top, 4)
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
    
    private func buildNavigationLinks() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: {
                buildNavigationLinkDestinationView($0)
            },
            label: {
                EmptyView()
            }
        )
    }
}

extension ChatView {
    @ViewBuilder
    private func buildNavigationLinkDestinationView(
        _ type: Binding<ChatNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case let .chatSetting(conversation):
            ChatSettingView(
                viewModel: ChatSettingViewModel(
                    conversation: conversation,
                    delegate: viewModel
                )
            )
        case let .openImages(message):
            MessageImagesView(
                viewModel: MessageImagesViewModel(
                    message: message,
                    delegate: viewModel
                )
            )
        }
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<ChatFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case let .urlDetail(url):
            SafariView(url: url)
        case let .messageQuickReaction(message, rect):
            MessageQuickReactionView(
                viewModel: MessageQuickReactionViewModel(
                    input: MessageQuickReactionInput(
                        message: message,
                        rect: rect
                    )
                )
            )
            .onDisappear {
                UIView.setAnimationsEnabled(true)
            }
        case let .messageActionDetail(normalMessageModel, rect):
            MessageActionDetailView(
                viewModel: MessageActionDetailViewModel(
                    input: MessageActionDetailInput(
                        message: normalMessageModel.message,
                        normalMessageModel: normalMessageModel,
                        rect: rect
                    )
                )
            )
            .onDisappear {
                UIView.setAnimationsEnabled(true)
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
