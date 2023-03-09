//
//  ConversationListViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import Combine
import Foundation

// MARK: - ConversationListViewModelDelegate

protocol ConversationListViewModelDelegate: AnyObject {}

// MARK: - ConversationListViewModelType

protocol ConversationListViewModelType:
    ContactListViewModelDelegate,
    ViewModelType where State == ConversationListViewModel.State, Action == ConversationListViewModel.Action {}

extension ConversationListViewModel {
    struct State {
        enum NavigationLinkItem {
            case chat(Conversation)
        }

        var conversations = [Conversation]()
        var error: Error?
        var viewState = ViewState.content

        var navigationLinkItem: NavigationLinkItem?
    }

    enum Action {
        case loadData
        case openChat(Conversation)
    }
}

// MARK: - ConversationListViewModel

final class ConversationListViewModel: ConversationListViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private let conversationService: ConversationServiceType
    private weak var delegate: ConversationListViewModelDelegate?

    // MARK: Action

    private let loadDataTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         conversationService: ConversationServiceType = ConversationService.default,
         delegate: ConversationListViewModelDelegate? = nil) {
        self.state = state
        self.conversationService = conversationService
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .loadData:
            loadDataTrigger.send()
        case let .openChat(conversation):
            state.navigationLinkItem = .chat(conversation)
        }
    }

    private func configure() {
        loadDataTrigger
            .handleEvents(receiveOutput: { [weak self] in
                self?.state.viewState = .loading

            })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<[Conversation], Error>().eraseToAnyPublisher()
                }
                return self.conversationService
                    .getConversations()
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(conversations):
                    self?.state.conversations = conversations
                    self?.state.viewState = .content
                case let .failure(error):
                    self?.state.error = error
                    self?.state.viewState = .error
                }
            })
            .store(in: &cancellables)
    }
}

// MARK: ContactListViewModelDelegate

extension ConversationListViewModel: ContactListViewModelDelegate {
    func didCreateConversation(_ conversation: Conversation) {
        send(.openChat(conversation))
    }
}
