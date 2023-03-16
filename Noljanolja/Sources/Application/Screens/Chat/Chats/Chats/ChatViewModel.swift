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
    }

    enum Action {
        case loadData
        case reloadData
        case loadMoreData
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
    private let loadMoreDataTrigger = PassthroughSubject<Void, Never>()
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
        case .loadMoreData:
            loadMoreDataTrigger.send()
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
            })
            .store(in: &cancellables)

        let getMessagesTrigger = Publishers.Merge3(
            loadDataTrigger
                .first()
                .map { _ -> Message? in nil },
            reloadDataTrigger
                .map { _ -> Message? in nil },
            loadMoreDataTrigger
                .filter { [weak self] in self?.state.footerViewState != .noMoreData }
                .withLatestFrom(messagesSubject) { $1.last }
        )

        getMessagesTrigger
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.state.viewState = .loading
                self?.state.footerViewState = .loading
            })
            .flatMapLatestToResult { [weak self] lastMessage in
                guard let self else {
                    return Empty<[Message], Error>().eraseToAnyPublisher()
                }
                return self.conversationDetailService
                    .getMessages(
                        conversationID: self.state.conversation.id,
                        beforeMessageID: lastMessage?.id
                    )
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(messages):
                    let currentMesages = self?.messagesSubject.value ?? []
                    let newMessages = currentMesages + messages
                    self?.messagesSubject.send(newMessages)
                    self?.state.viewState = .content
                    self?.state.footerViewState = messages.isEmpty ? .noMoreData : .loading
                case let .failure(error):
                    self?.state.error = error
                    self?.state.viewState = .error
                    self?.state.footerViewState = .error
                }
            })
            .store(in: &cancellables)

        userService
            .currentUserPublisher
            .sink(receiveValue: { [weak self] in self?.currentUserSubject.send($0) })
            .store(in: &cancellables)
    }
}
