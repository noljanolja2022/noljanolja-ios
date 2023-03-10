//
//  ConversationListViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import Combine
import CombineExt
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

        var conversations = [ConversationItemModel]()
        var error: Error?
        var viewState = ViewState.content

        var navigationLinkItem: NavigationLinkItem?
    }

    enum Action {
        case loadData
        case openChat(ConversationItemModel)
    }
}

// MARK: - ConversationListViewModel

final class ConversationListViewModel: ConversationListViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private let profileService: ProfileServiceType
    private let conversationService: ConversationServiceType
    private weak var delegate: ConversationListViewModelDelegate?

    // MARK: Action

    private let loadDataTrigger = PassthroughSubject<Void, Never>()
    private let openChatTrigger = PassthroughSubject<ConversationItemModel, Never>()

    // MARK: Data

    private let currentUserSubject = PassthroughSubject<User, Never>()
    private let conversationsSubject = PassthroughSubject<[Conversation], Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         profileService: ProfileServiceType = ProfileService.default,
         conversationService: ConversationServiceType = ConversationService.default,
         delegate: ConversationListViewModelDelegate? = nil) {
        self.state = state
        self.profileService = profileService
        self.conversationService = conversationService
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .loadData:
            loadDataTrigger.send()
        case let .openChat(conversation):
            openChatTrigger.send(conversation)
        }
    }

    private func configure() {
        Publishers.CombineLatest(currentUserSubject, conversationsSubject)
            .map { currentUser, conversations in
                conversations
                    .map {
                        ConversationItemModel(
                            currentUser: currentUser,
                            conversation: $0
                        )
                    }
            }
            .sink(receiveValue: { [weak self] in
                self?.state.conversations = $0
                self?.state.viewState = .content
            })
            .store(in: &cancellables)

        profileService
            .getProfileIfNeeded()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.currentUserSubject.send($0) }
            )
            .store(in: &cancellables)

        loadDataTrigger
            .first()
            .handleEvents(receiveOutput: { [weak self] in self?.state.viewState = .loading })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<[Conversation], Error>().eraseToAnyPublisher()
                }
                return self.conversationService.getConversations()
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(conversations):
                    logger.info("Get conversations successful")
                    self?.conversationsSubject.send(conversations)
                case let .failure(error):
                    logger.info("Get conversations failed - \(error.localizedDescription)")
                    self?.state.error = error
                    self?.state.viewState = .error
                }
            })
            .store(in: &cancellables)

        openChatTrigger
            .withLatestFrom(conversationsSubject) { ($0, $1) }
            .compactMap { conversationItemModel, conversations in
                conversations.first(where: { $0.id == conversationItemModel.id })
            }
            .sink(receiveValue: { [weak self] in self?.state.navigationLinkItem = .chat($0) })
            .store(in: &cancellables)
    }
}

// MARK: ContactListViewModelDelegate

extension ConversationListViewModel: ContactListViewModelDelegate {
    func didCreateConversation(_ conversation: Conversation) {
        state.navigationLinkItem = .chat(conversation)
    }
}
