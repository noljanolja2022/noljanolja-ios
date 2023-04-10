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

    @Published var navigationType: ChatNavigationType?

    // MARK: Action

    let loadMoreDataTrigger = PassthroughSubject<Int, Never>()
    let openChatSettingSubject = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let conversationID: Int
    
    private let userService: UserServiceType
    private let conversationService: ConversationServiceType
    private let messageService: MessageServiceType
    private weak var delegate: ChatViewModelDelegate?

    // MARK: Private

    private let loadPreviousDataTrigger = PassthroughSubject<Void, Never>()
    private let loadNextDataTrigger = PassthroughSubject<Void, Never>()
    private let reloadDataTrigger = PassthroughSubject<Void, Never>()
    private let seenTrigger = PassthroughSubject<Int, Never>()

    private let conversationSubject = CurrentValueSubject<Conversation?, Never>(nil)
    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)
    private let messagesSubject = CurrentValueSubject<[Message], Never>([])

    private var cancellables = Set<AnyCancellable>()

    init(conversationID: Int,
         userService: UserServiceType = UserService.default,
         conversationService: ConversationServiceType = ConversationService.default,
         messageService: MessageServiceType = MessageService.default,
         delegate: ChatViewModelDelegate? = nil) {
        self.conversationID = conversationID
        self.userService = userService
        self.conversationService = conversationService
        self.messageService = messageService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
        configureSeenMessage()
        configureLoadData()
        configureActions()
    }

    private func configureBindData() {
        Publishers.CombineLatest(
            currentUserSubject.compactMap { $0 }.removeDuplicates(),
            conversationSubject.compactMap { $0 }.removeDuplicates()
        )
        .map { currentUser, conversation in
            conversation.displayTitle(currentUser) ?? ""
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
                .withLatestFrom(messagesSubject)
                .map { messages -> (Message?, Message?) in (messages.last, nil) }
                .handleEvents(receiveOutput: { [weak self] _ in
                    self?.footerViewState = .loading
                }),
            loadNextDataTrigger
                .filter { [weak self] in self?.headerViewState != .noMoreData }
                .withLatestFrom(messagesSubject)
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
                case let .success(messages):
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
            .first()
            .sink(receiveValue: { [weak self] messages in
                self?.loadNextDataTrigger.send()
                if messages.isEmpty {
                    self?.reloadDataTrigger.send()
                }
            })
            .store(in: &cancellables)

        // MARK: Load local messages

        isAppearSubject
            .filter { $0 }
            .first()
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
                    self?.messagesSubject.send(messages)
                case let .failure(error):
                    logger.error("Get local messages failed: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)

        isAppearSubject
            .filter { $0 }
            .first()
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
                case let .failure(error):
                    return
                }
            })
            .store(in: &cancellables)

        userService
            .currentUserPublisher
            .sink(receiveValue: { [weak self] in self?.currentUserSubject.send($0) })
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
