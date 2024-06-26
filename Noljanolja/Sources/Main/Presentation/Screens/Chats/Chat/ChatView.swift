//
//  ChatView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/03/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI
import SwiftUIX

// MARK: - ChatView

struct ChatView<ViewModel: ChatViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode
    @State var scrollOffset = CGFloat.zero
    @State private var isPresented = false

    var body: some View {
        buildBodyView()
    }

    func buildBodyView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLinks()
        }
        .navigationBar(backButtonTitle: "", presentationMode: presentationMode, middle: { middle }, trailing: { trailing })
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
        .onReceive(viewModel.closeAction) {
            presentationMode.wrappedValue.dismiss()
        }
        .alert(item: $viewModel.alertState) {
            Alert($0) { action in
                switch action {
                case let .deleteMessage(message):
                    viewModel.deleteMessageAction.send(message)
                case .none:
                    break
                }
            }
        }
        .fullScreenCover(
            unwrapping: $viewModel.fullScreenCoverType,
            content: {
                buildFullScreenCoverDestinationView($0)
            }
        )
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildMainView()
            buildReplyToMessageView()
            buildInputView()
        }
        .background(ColorAssets.neutralLight.swiftUIColor)
        .statefull(
            state: $viewModel.viewState,
            isEmpty: { viewModel.chatItems.isEmpty },
            loading: buildLoadingView,
            empty: buildEmptyView,
            error: buildErrorView
        )
    }

    private func buildMainView() -> some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottomTrailing) {
                buildMessagesView()
                buildQuickScrollDownView(proxy)
            }
            .onReceive(viewModel.scrollToChatItemAction) { index, anchor in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo("\(ChatItemModelType.viewIdPrefix)_\(index)", anchor: anchor)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildMessagesView() -> some View {
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

    @ViewBuilder
    private func buildReplyToMessageView() -> some View {
        if let message = viewModel.replyToMessage {
            PreviewReplyMessageView(
                model: PreviewReplyMessageModel(message),
                removeAction: {
                    viewModel.replyToMessage = nil
                }
            )
        }
    }

    private func buildInputView() -> some View {
        ChatInputView(
            viewModel: ChatInputViewModel(
                conversationID: viewModel.conversationID,
                delegate: viewModel
            )
        )
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
    
    @ViewBuilder
    private var middle: some View {
        HStack {
            WebImage(
                url: URL(string: viewModel.avatar),
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(width: 50 * 3, height: 50 * 3),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .indicator(.activity)
            .scaledToFill()
            .frame(width: 34, height: 34)
            .background(ColorAssets.neutralGrey.swiftUIColor)
            .cornerRadius(10)
            .padding(.trailing, 10)

            Text(viewModel.title)
                .lineLimit(1)
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            Spacer()
        }
    }
    
    @ViewBuilder
    private var trailing: some View {
        if viewModel.isChatSettingEnabled {
            Button(
                action: {
                    viewModel.openChatSettingSubject.send()
                },
                label: {
                    ImageAssets.icMenu.swiftUIImage
                        .padding(10)
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            )
        } else {
            Spacer()
        }
    }
}

extension ChatView {
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildEmptyView() -> some View {
        EmptyView()
    }

    private func buildErrorView() -> some View {
        EmptyView()
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
            if message.attachments.count > 1 {
                MessageImagesView(
                    viewModel: MessageImagesViewModel(
                        message: message,
                        delegate: viewModel
                    )
                )
            } else {
                NavigationView {
                    ImageDetailView(
                        viewModel: ImageDetailViewModel(
                            imageUrls: message.attachments.compactMap { $0.getPhotoURL(conversationID: message.conversationID) },
                            delegate: viewModel
                        )
                    )
                }
                .navigationBarHidden(true)
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
        case let .forwardMessage(message):
            ForwardMessageContactListView(
                viewModel: ForwardMessageContactListViewModel(message: message)
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
        case let .messageActionDetail(normalMessageModel, rect):
            let viewModel = MessageActionDetailViewModel(
                input: MessageActionDetailInput(
                    message: normalMessageModel.message,
                    normalMessageModel: normalMessageModel,
                    rect: rect
                ),
                delegate: viewModel
            )
            MessageActionDetailView(
                viewModel: viewModel
            )
            .animation(.spring())
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
