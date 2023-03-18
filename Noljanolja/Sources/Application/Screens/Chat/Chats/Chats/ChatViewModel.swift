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

// MARK: - ChatViewModelType

protocol ChatViewModelType:
    ViewModelType where State == ChatViewModel.State, Action == ChatViewModel.Action {}

extension ChatViewModel {
    struct State {
        let conversation: Conversation

        var chatItems = [ChatItemModelType]()
        var error: Error?

        var viewState = ViewState.content
        var footerViewState = StatefullFooterViewState.loading
        var headerViewState = StatefullFooterViewState.loading
    }

    enum Action {
        case loadData
        case reloadData
        case loadMoreData(Int)
    }
}

// MARK: - ChatViewModel

final class ChatViewModel: ChatViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private let userService: UserServiceType
    private let conversationDetailService: ConversationDetailServiceType
    private weak var delegate: ChatViewModelDelegate?

    // MARK: Action

    private let loadDataTrigger = PassthroughSubject<Void, Never>()
    private let loadMoreDataTrigger = PassthroughSubject<Int, Never>()
    private let loadPreviousDataTrigger = PassthroughSubject<Void, Never>()
    private let loadNextDataTrigger = PassthroughSubject<Void, Never>()
    private let reloadDataTrigger = PassthroughSubject<Void, Never>()

    // MARK: Data

    private let currentUserSubject = PassthroughSubject<User, Never>()
    private let messagesSubject = CurrentValueSubject<[Message], Never>([])

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State,
         userService: UserServiceType = UserService.default,
         conversationDetailService: ConversationDetailServiceType = ConversationDetailService.default,
         delegate: ChatViewModelDelegate? = nil) {
        self.state = state
        self.userService = userService
        self.conversationDetailService = conversationDetailService
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .loadData:
            loadDataTrigger.send()
        case .reloadData:
            reloadDataTrigger.send()
        case let .loadMoreData(index):
            loadMoreDataTrigger.send(index)
        }
    }

    private func configure() {
        Publishers.CombineLatest(currentUserSubject, messagesSubject)
            .map { currentUser, messages in
                MessageItemModelBuilder(currentUser: currentUser, messages: messages)
                    .build()
            }
            .sink(receiveValue: { [weak self] in
                self?.state.chatItems = $0
                self?.state.viewState = .content
            })
            .store(in: &cancellables)

        let getMessagesTrigger = Publishers.Merge3(
            reloadDataTrigger
                .map { _ -> (Message?, Message?) in (nil, nil) },
            loadPreviousDataTrigger
                .filter { [weak self] in self?.state.footerViewState != .noMoreData }
                .withLatestFrom(messagesSubject)
                .map { messages -> (Message?, Message?) in (messages.last, nil) }
                .handleEvents(receiveOutput: { [weak self] _ in
                    self?.state.footerViewState = .loading
                }),
            loadNextDataTrigger
                .filter { [weak self] in self?.state.headerViewState != .noMoreData }
                .withLatestFrom(messagesSubject)
                .map { messages -> (Message?, Message?) in (nil, messages.first) }
                .handleEvents(receiveOutput: { [weak self] _ in
                    self?.state.headerViewState = .loading
                })
        )

        getMessagesTrigger
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.state.viewState = .loading
            })
            .flatMapToResult { [weak self] lastMessage, firstMessage in
                guard let self else {
                    return Empty<[Message], Error>().eraseToAnyPublisher()
                }
                return self.conversationDetailService
                    .getMessages(
                        conversationID: self.state.conversation.id,
                        beforeMessageID: lastMessage?.id,
                        afterMessageID: firstMessage?.id
                    )
                    .handleEvents(receiveOutput: { [weak self] messages in
                        if lastMessage != nil {
                            self?.state.footerViewState = messages.isEmpty ? .noMoreData : .loading
                        }
                        if firstMessage != nil {
                            self?.state.headerViewState = messages.isEmpty ? .noMoreData : .loading
                        }
                    })
                    .eraseToAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(messages):
                    break
                case let .failure(error):
                    self?.state.error = error
                    self?.state.viewState = .error
                }
            })
            .store(in: &cancellables)

        loadDataTrigger
            .first()
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<[Message], Error>().eraseToAnyPublisher()
                }
                return self.conversationDetailService
                    .getLocalMessages(conversationID: self.state.conversation.id)
                    .eraseToAnyPublisher()
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(messages):
                    logger.info("Get local messages successfull")
                    self?.messagesSubject.send(messages)
                    if messages.isEmpty {
                        self?.reloadDataTrigger.send()
                    }
                case let .failure(error):
                    logger.error("Get local messages failed: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)

        messagesSubject
            .dropFirst()
            .first()
            .sink(receiveValue: { [weak self] _ in self?.loadNextDataTrigger.send() })
            .store(in: &cancellables)

        loadMoreDataTrigger
            .sink(receiveValue: { [weak self] index in
                guard let self else { return }
                if (self.state.chatItems.count > 10 && index == self.state.chatItems.count - 10)
                    || (self.state.chatItems.count < 10 && index == self.state.chatItems.count - 1) {
                    self.loadPreviousDataTrigger.send()
                } else if index == 0 {
                    self.loadNextDataTrigger.send()
                }
            })
            .store(in: &cancellables)

        userService
            .currentUserPublisher
            .sink(receiveValue: { [weak self] in self?.currentUserSubject.send($0) })
            .store(in: &cancellables)
    }
}
