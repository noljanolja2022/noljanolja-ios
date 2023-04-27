//
//  ChatViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/03/2023.
//
//

import Combine
import Foundation

// MARK: - ChatViewModelDelegate

protocol ChatViewModelDelegate: AnyObject {}

// MARK: - ChatViewModel

final class ChatViewModel: ViewModel {
    // MARK: State

    @Published var title = ""
    @Published var isChatSettingEnabled = false

    @Published var chatItems = [ChatItemModelType]()
    @Published var error: Error?

    @Published var viewState = ViewState.loading
    @Published var footerViewState = StatefullFooterViewState.loading
    @Published var headerViewState = StatefullFooterViewState.loading

    // MARK: Navigations

    @Published var navigationType: ChatNavigationType?
    @Published var fullScreenCoverType: ChatFullScreenCoverType?

    // MARK: Action

    let closeAction = PassthroughSubject<Void, Never>()
    let chatItemAction = PassthroughSubject<ChatItemActionType, Never>()
    let loadMoreDataTrigger = PassthroughSubject<Int, Never>()
    let openChatSettingSubject = PassthroughSubject<Void, Never>()

    private let loadPreviousDataTrigger = PassthroughSubject<Void, Never>()
    private let loadNextDataTrigger = PassthroughSubject<Void, Never>()
    private let reloadDataTrigger = PassthroughSubject<Void, Never>()
    private let seenTrigger = PassthroughSubject<Int, Never>()

    // MARK: Dependencies

    let conversationID: Int
    
    private let userService: UserServiceType
    private let conversationService: ConversationServiceType
    private let messageService: MessageServiceType
    private let conversationSocketService: ConversationSocketServiceType
    private weak var delegate: ChatViewModelDelegate?

    // MARK: Private

    private let conversationSubject = CurrentValueSubject<Conversation?, Never>(nil)
    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)
    private let messagesSubject = CurrentValueSubject<[Message], Never>([])

    private var cancellables = Set<AnyCancellable>()

    init(conversationID: Int,
         userService: UserServiceType = UserService.default,
         conversationService: ConversationServiceType = ConversationService.default,
         messageService: MessageServiceType = MessageService.default,
         conversationSocketService: ConversationSocketServiceType = ConversationSocketService.default,
         delegate: ChatViewModelDelegate? = nil) {
        self.conversationID = conversationID
        self.userService = userService
        self.conversationService = conversationService
        self.messageService = messageService
        self.conversationSocketService = conversationSocketService
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
        .map { currentUser, conversation in
            conversation.getDisplayTitleForDetail(currentUser: currentUser) ?? ""
        }
        .removeDuplicates()
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self] in self?.title = $0 })
        .store(in: &cancellables)

        Publishers
            .CombineLatest3(
                currentUserSubject
                    .compactMap { $0 }
                    .removeDuplicates(),
                conversationSubject
                    .compactMap { $0 }
                    .removeDuplicates(),
                messagesSubject
                    .compactMap { $0 }
                    .filter { !$0.isEmpty }
                    .removeDuplicates()
            )
            .map { currentUser, conversation, messages in
                MessageItemModelBuilder(
                    currentUser: currentUser,
                    conversation: conversation,
                    messages: messages
                )
                .build()
            }
            .sink(receiveValue: { [weak self] in
                self?.chatItems = $0
                self?.viewState = .content
            })
            .store(in: &cancellables)

        conversationSubject
            .sink { [weak self] in
                switch $0?.type {
                case .single, .unknown, .none:
                    self?.isChatSettingEnabled = false
                case .group:
                    self?.isChatSettingEnabled = true
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
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
            })
            .flatMapToResult { [weak self] lastMessage, firstMessage in
                guard let self else {
                    return Empty<[Message], Error>().eraseToAnyPublisher()
                }
                return self.messageService
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

        loadMoreDataTrigger
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
                return self.messageService
                    .getLocalMessages(conversationID: self.conversationID)
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(messages):
                    logger.info("Get local messages successfull")
                    let messages = messages.filter { $0.type.isSupported }
                    self?.messagesSubject.send(messages)
                case let .failure(error):
                    logger.error("Get local messages failed: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)

        isAppearSubject
            .first(where: { $0 })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationService
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

        userService
            .getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in self?.currentUserSubject.send($0) })
            .store(in: &cancellables)
    }

    private func configureSocket() {
        conversationSocketService.register()

        conversationSocketService
            .getConversationStream(id: conversationID)
            .withLatestFrom(currentUserSubject.compactMap { $0 }) { ($0, $1) }
            .sink(receiveValue: { [weak self] result, currentUser in
                guard let self else { return }
                switch result {
                case let .success(conversation):
                    print("BBBBB", conversation)
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
                case let .failure(error):
                    print("BBBBB", error.localizedDescription)
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
                guard let message = messages.first(where: { $0.id != nil && $0.sender.id != currentUser.id }),
                      !message.seenBy.contains(currentUser.id),
                      let messageID = message.id,
                      isAppear else {
                    return
                }
                self?.seenTrigger.send(messageID)
            })
            .store(in: &cancellables)

        seenTrigger
            .flatMapLatestToResult { [weak self] messageID in
                guard let self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }
                return self.messageService.seenMessage(conversationID: self.conversationID, messageID: messageID)
            }
            .sink(receiveValue: { _ in })
            .store(in: &cancellables)
    }

    private func configureActions() {
        chatItemAction
            .sink { [weak self] actionType in
                guard let self else { return }
                switch actionType {
                case let .openURL(urlString):
                    guard let url = URL(string: urlString),
                          url.scheme == "https" || url.scheme == "http" else { return }
                    self.fullScreenCoverType = .openUrl(url)
                case let .openImageDetail(url):
                    guard let url else { return }
                    self.fullScreenCoverType = .openImageDetail(url)
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
    }
}

// MARK: ChatSettingViewModelDelegate

extension ChatViewModel: ChatSettingViewModelDelegate {
    func didLeaveGroupChat() {
        closeAction.send()
    }
}
