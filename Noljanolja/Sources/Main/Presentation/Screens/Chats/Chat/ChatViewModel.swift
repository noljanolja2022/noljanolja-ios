//
//  ChatViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/03/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation
import SwiftUIX
import UIKit

// MARK: - ChatViewModelDelegate

protocol ChatViewModelDelegate: AnyObject {
    func chatViewModel(openConversation user: User)
}

// MARK: - ChatViewModel

final class ChatViewModel: ViewModel {
    // MARK: State

    @Published var alertState: AlertState<ChatAlertActionType>?

    @Published var title = ""
    @Published var avatar = ""
    @Published var isChatSettingEnabled = false

    @Published var chatItems = [ChatItemModelType]()
    @Published var replyToMessage: Message?
    @Published var error: Error?

    @Published var viewState = ViewState.loading
    @Published var footerViewState = StatefullFooterViewState.loading
    @Published var headerViewState = StatefullFooterViewState.loading

    // MARK: Navigations

    @Published var navigationType: ChatNavigationType?
    @Published var fullScreenCoverType: ChatFullScreenCoverType?

    // MARK: Action

    private let sendAction = PassthroughSubject<SendMessageType, Never>()

    let closeAction = PassthroughSubject<Void, Never>()
    let chatItemAction = PassthroughSubject<(ChatItemModelType, NormalMessageModel.ActionType), Never>()
    let loadMoreDataAction = PassthroughSubject<Int, Never>()
    let openChatSettingSubject = PassthroughSubject<Void, Never>()
    let reactionAction = PassthroughSubject<(Message, ReactIcon), Never>()
    let openDetailVideoAction = PassthroughSubject<Video?, Never>()
    let scrollToChatItemAction = PassthroughSubject<(Int, UnitPoint), Never>()
    let deleteMessageAction = PassthroughSubject<Message, Never>()

    private let loadPreviousDataTrigger = PassthroughSubject<Void, Never>()
    private let loadNextDataTrigger = PassthroughSubject<Void, Never>()
    private let reloadDataTrigger = PassthroughSubject<Void, Never>()
    private let seenTrigger = PassthroughSubject<Int, Never>()

    // MARK: Dependencies

    let conversationID: Int

    private let userUseCases: UserUseCases
    private let conversationUseCases: ConversationUseCases
    private let messageUseCases: MessageUseCases
    private let conversationSocketService: ConversationSocketServiceType
    private let reactionIconsUseCases: ReactionIconsUseCasesProtocol
    private let messageReactionUseCases: MessageReactionUseCases
    private weak var delegate: ChatViewModelDelegate?

    // MARK: Private

    private let conversationSubject = CurrentValueSubject<Conversation?, Never>(nil)
    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)
    private let reactionIconsSubject = CurrentValueSubject<[ReactIcon], Never>([])
    private let messagesSubject = CurrentValueSubject<[Message], Never>([])

    private var cancellables = Set<AnyCancellable>()

    init(conversationID: Int,
         userUseCases: UserUseCases = UserUseCasesImpl.default,
         conversationUseCases: ConversationUseCases = ConversationUseCasesImpl.default,
         messageUseCases: MessageUseCases = MessageUseCasesImpl.default,
         conversationSocketService: ConversationSocketServiceType = ConversationSocketService.default,
         reactionIconsUseCases: ReactionIconsUseCasesProtocol = ReactionIconsUseCases.default,
         messageReactionUseCases: MessageReactionUseCases = MessageReactionUseCasesImpl.shared,
         delegate: ChatViewModelDelegate? = nil) {
        self.conversationID = conversationID
        self.userUseCases = userUseCases
        self.conversationUseCases = conversationUseCases
        self.messageUseCases = messageUseCases
        self.conversationSocketService = conversationSocketService
        self.reactionIconsUseCases = reactionIconsUseCases
        self.messageReactionUseCases = messageReactionUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
        configureSeenMessage()
        configureLoadData()
        configureSocket()
        configureActions()
    }

    private func configureBindData() {
        Publishers.CombineLatest(
            currentUserSubject.compactMap { $0 }.removeDuplicates(),
            conversationSubject.compactMap { $0 }.removeDuplicates()
        )
        .map { currentUser, conversation -> [String] in
            let name = conversation.getDisplayTitleForDetail(currentUser: currentUser) ?? ""
            let avatar = conversation.getAvatar(currentUser: currentUser) ?? ""
            return [name, avatar]
        }
        .removeDuplicates()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] user in
            self?.title = user[0]
            self?.avatar = user[1]
        }
        .store(in: &cancellables)

        Publishers
            .CombineLatest4(
                currentUserSubject
                    .compactMap { $0 }
                    .removeDuplicates(),
                conversationSubject
                    .compactMap { $0 }
                    .removeDuplicates(),
                reactionIconsSubject
                    .removeDuplicates(),
                messagesSubject
                    .compactMap { $0 }
                    .filter { !$0.isEmpty }
                    .removeDuplicates()
            )
            .map { currentUser, conversation, reactionIcons, messages in
                ChatItemModelBuilder(
                    currentUser: currentUser,
                    conversation: conversation,
                    reactionIcons: reactionIcons,
                    messages: messages
                )
                .build()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.chatItems = $0
                self?.viewState = .content
            })
            .store(in: &cancellables)

        conversationSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                switch $0?.type {
                case .single, .group:
                    self?.isChatSettingEnabled = true
                case .unknown, .none:
                    self?.isChatSettingEnabled = false
                }
            }
            .store(in: &cancellables)
    }

    private func configureLoadData() {
        // MARK: Load remote messages

        let getMessagesTrigger = Publishers.Merge3(
            reloadDataTrigger
                .map { _ -> (Message?, Message?) in (nil, nil) },
            loadPreviousDataTrigger
                .filter { [weak self] in self?.footerViewState != .noMoreData }
                .withLatestFrom(messagesSubject.filter { !$0.isEmpty })
                .map { messages -> (Message?, Message?) in (messages.last, nil) }
                .handleEvents(receiveOutput: { [weak self] _ in
                    self?.footerViewState = .loading
                }),
            loadNextDataTrigger
                .filter { [weak self] in self?.headerViewState != .noMoreData }
                .withLatestFrom(messagesSubject.filter { !$0.isEmpty })
                .map { messages -> (Message?, Message?) in (nil, messages.first) }
                .handleEvents(receiveOutput: { [weak self] _ in
                    self?.headerViewState = .loading
                })
        )

        getMessagesTrigger
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
            })
            .flatMapToResult { [weak self] lastMessage, firstMessage in
                guard let self else {
                    return Empty<[Message], Error>().eraseToAnyPublisher()
                }
                return self.messageUseCases
                    .getMessages(
                        conversationID: self.conversationID,
                        beforeMessageID: lastMessage?.id,
                        afterMessageID: firstMessage?.id
                    )
                    .handleEvents(receiveOutput: { [weak self] messages in
                        if lastMessage != nil {
                            self?.footerViewState = messages.isEmpty ? .noMoreData : .loading
                        }
                        if firstMessage != nil {
                            self?.headerViewState = messages.isEmpty ? .noMoreData : .loading
                        }
                    })
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.viewState = .content
                case let .failure(error):
                    self?.error = error
                    self?.viewState = .error
                }
            })
            .store(in: &cancellables)

        loadMoreDataAction
            .sink(receiveValue: { [weak self] index in
                guard let self else { return }
                let chekingCount = 20
                if (self.chatItems.count > chekingCount && index == self.chatItems.count - chekingCount)
                    || (self.chatItems.count < chekingCount && index == self.chatItems.count - 1) {
                    self.loadPreviousDataTrigger.send()
                } else if index == 0 {
                    self.loadNextDataTrigger.send()
                }
            })
            .store(in: &cancellables)

        messagesSubject
            .dropFirst()
            .first()
            .filter { $0.isEmpty }
            .sink(receiveValue: { [weak self] _ in
                self?.reloadDataTrigger.send()
            })
            .store(in: &cancellables)

        // MARK: Load local messages

        isAppearSubject
            .first(where: { $0 })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<[Message], Error>().eraseToAnyPublisher()
                }
                return self.messageUseCases
                    .getLocalMessages(conversationID: self.conversationID)
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(messages):
                    let messages = messages.filter { $0.type.isSupported }
                    self?.messagesSubject.send(messages)
                case .failure:
                    break
                }
            })
            .store(in: &cancellables)

        isAppearSubject
            .first(where: { $0 })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationUseCases
                    .getConversation(conversationID: self.conversationID)
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(conversation):
                    self?.conversationSubject.send(conversation)
                case .failure:
                    return
                }
            })
            .store(in: &cancellables)

        userUseCases
            .getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in self?.currentUserSubject.send($0) })
            .store(in: &cancellables)

        isAppearSubject
            .first(where: { $0 })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<[ReactIcon], Error> in
                guard let self else {
                    return Empty<[ReactIcon], Error>().eraseToAnyPublisher()
                }
                return self.reactionIconsUseCases.getReactionIcons()
            }
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.reactionIconsSubject.send(model)
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func configureSocket() {
        conversationSocketService.register()

        conversationSocketService
            .getConversationStream(id: conversationID)
            .withLatestFrom(currentUserSubject.compactMap { $0 }) { ($0, $1) }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result, currentUser in
                guard let self else { return }
                switch result {
                case let .success(conversation):
                    let lastMessage = conversation.messages.sorted { $0.createdAt > $1.createdAt }.first
                    switch lastMessage?.type {
                    case .eventLeft:
                        if lastMessage?.leftParticipants.map({ $0.id }).contains(currentUser.id) ?? false {
                            self.closeAction.send()
                            self.navigationType = nil
                        }
                    case .plaintext, .photo, .sticker, .eventUpdated, .eventJoined, .unknown, .none:
                        break
                    }
                case .failure:
                    break
                }
            })
            .store(in: &cancellables)
    }

    private func configureSeenMessage() {
        Publishers
            .CombineLatest3(
                currentUserSubject.compactMap { $0 }.removeDuplicates(),
                messagesSubject.compactMap { $0 }.removeDuplicates(),
                isAppearSubject.compactMap { $0 }.removeDuplicates()
            )
            .sink(receiveValue: { [weak self] (currentUser: User, messages: [Message], isAppear: Bool) in
                guard isAppear else {
                    return
                }
                let messages = messages.filter { $0.id != nil && $0.sender.id != currentUser.id }
                for message in messages where !message.seenBy.contains(currentUser.id) {
                    if let messageID = message.id {
                        self?.seenTrigger.send(messageID)
                    }
                }
            })
            .store(in: &cancellables)

        seenTrigger
            .subscribe(on: DispatchQueue.global())
            .flatMapLatestToResult { [weak self] messageID in
                guard let self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }
                return self.messageUseCases.seenMessage(conversationID: self.conversationID, messageID: messageID)
            }
            .sink(receiveValue: { _ in })
            .store(in: &cancellables)
    }

    private func configureActions() {
        let conversationID = conversationID

        sendAction
            .map { [weak self] sendMessageType in
                switch sendMessageType {
                case let .text(message):
                    return SendMessageRequest(
                        conversationID: conversationID,
                        type: .plaintext,
                        message: message,
                        replyToMessage: self?.replyToMessage
                    )
                case let .images(images):
                    return SendMessageRequest(
                        conversationID: conversationID,
                        type: .photo,
                        attachments: .images(images),
                        replyToMessage: self?.replyToMessage
                    )
                case let .photoAssets(photos):
                    return SendMessageRequest(
                        conversationID: conversationID,
                        type: .photo,
                        attachments: .photos(photos),
                        replyToMessage: self?.replyToMessage
                    )
                case let .sticker(stickerPack, sticker):
                    return SendMessageRequest(
                        conversationID: conversationID,
                        type: .sticker,
                        sticker: (stickerPack, sticker),
                        replyToMessage: self?.replyToMessage
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.replyToMessage = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    self?.scrollToChatItemAction.send((0, .top))
                }
            })
            .flatMapToResult { [weak self] request in
                guard let self else {
                    return Empty<Message, Error>().eraseToAnyPublisher()
                }
                return self.messageUseCases
                    .sendMessage(request: request)
            }
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &cancellables)

        chatItemAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chatItemModel, actionType in
                guard let self else { return }

                let dismissKeyboard = { (completion: @escaping () -> Void) in
                    if Keyboard.main.isShowing {
                        Keyboard.main.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            completion()
                        }
                    } else {
                        completion()
                    }
                }

                let scrollToMessage = { [weak self] (completion: @escaping () -> Void) in
                    if let self, let index = self.chatItems.firstIndex(where: { $0 == chatItemModel }) {
                        self.scrollToChatItemAction.send((index, .center))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            completion()
                        }
                    } else {
                        completion()
                    }
                }

                switch actionType {
                case let .openURL(urlString):
                    guard let url = URL(string: urlString),
                          url.scheme == "https" || url.scheme == "http" else { return }
                    self.fullScreenCoverType = .urlDetail(url)
                case let .openImages(message):
                    self.navigationType = .openImages(message)
                case let .reaction(message, reactionIcon):
                    reactionAction.send((message, reactionIcon))
                case let .openVideoDetail(model):
                    openDetailVideoAction.send(model)
                case let .openMessageQuickReactionDetail(message, geometryProxy):
                    guard let geometryProxy else { return }
                    dismissKeyboard {
                        let contentRect = geometryProxy.frame(in: .global)
                        withoutAnimation {
                            self.fullScreenCoverType = .messageQuickReaction(message, contentRect)
                        }
                    }
                case let .openMessageActionDetail(normalMessageModel, geometryProxy):
                    guard let geometryProxy else { return }
                    dismissKeyboard {
                        scrollToMessage {
                            let contentRect = geometryProxy.frame(in: .global)
                            withoutAnimation {
                                self.fullScreenCoverType = .messageActionDetail(normalMessageModel, contentRect)
                            }
                        }
                    }
                }
            }
            .store(in: &cancellables)

        openChatSettingSubject
            .withLatestFrom(conversationSubject)
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.navigationType = .chatSetting($0)
            })
            .store(in: &cancellables)

        reactionAction
            .flatMapToResult { [weak self] message, reactionIcon -> AnyPublisher<Void, Error> in
                guard let self else {
                    return Fail<Void, Error>(error: CommonError.unknown).eraseToAnyPublisher()
                }
                return self.messageReactionUseCases.reactMessage(
                    message: message,
                    reactionId: reactionIcon.id
                )
            }
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &cancellables)

        openDetailVideoAction
            .receive(on: DispatchQueue.main)
            .sink { model in
                guard let model else { return }
                VideoDetailViewModel.shared.show(videoId: model.id)
            }
            .store(in: &cancellables)

        deleteMessageAction
            .flatMapLatestToResult { [weak self] message -> AnyPublisher<Void, Error> in
                guard let self, let messageId = message.id else {
                    return Fail<Void, Error>(error: CommonError.unknown).eraseToAnyPublisher()
                }
                return self.messageUseCases
                    .deleteMessage(conversationID: message.conversationID, messageID: messageId)
            }
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &cancellables)
    }
}

// MARK: ChatInputViewModelDelegate

extension ChatViewModel: ChatInputViewModelDelegate {
    func chatInputViewModel(type: SendMessageType) {
        sendAction.send(type)
    }
}

// MARK: ChatSettingViewModelDelegate

extension ChatViewModel: ChatSettingViewModelDelegate {
    func chatSettingViewModel(openConversation user: User) {
        delegate?.chatViewModel(openConversation: user)
    }

    func chatSettingViewModelLeaveChat() {
        closeAction.send()
    }
}

// MARK: MessageImagesViewModelDelegate

extension ChatViewModel: MessageImagesViewModelDelegate {
    func messageImagesViewModel(sendImage image: UIImage) {
        sendAction.send(.images([image]))
    }
}

// MARK: MessageActionDetailViewModelDelegate

extension ChatViewModel: MessageActionDetailViewModelDelegate {
    func messageActionDetailDelete(_ message: Message) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.alertState = AlertState(
                title: TextState(L10n.chatConfirmDeleteMessageTitle),
                message: TextState(L10n.chatConfirmDeleteMessage),
                primaryButton: .destructive(TextState(L10n.commonNo.uppercased())),
                secondaryButton: .default(TextState(L10n.commonYes.uppercased()), action: .send(.deleteMessage(message)))
            )
        }
    }

    func messageActionDetailReply(_ message: Message) {
        replyToMessage = message
    }

    func messageActionDetailForward(_ message: Message) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.navigationType = .forwardMessage(message)
        }
    }
}

// MARK: ImageDetailViewModelDelegate

extension ChatViewModel: ImageDetailViewModelDelegate {
    func imageDetailViewModel(sendImage image: UIImage) {}
}
