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

// MARK: - ConversationListViewModel

final class ConversationListViewModel: ViewModel {
    // MARK: State

    @Published var conversations = [ConversationItemModel]()
    @Published var error: Error?
    @Published var viewState = ViewState.content

    // MARK: Navigations

    @Published var navigationType: ConversationListNavigationType?
    @Published var fullScreenCoverType: ConversationListFullScreenCoverType? {
        willSet {
            guard newValue != nil else { return }
            isPresentingSubject.send(true)
        }
    }

    let isPresentingSubject = CurrentValueSubject<Bool, Never>(false)

    // MARK: Action

    let openChatTrigger = PassthroughSubject<ConversationItemModel, Never>()

    // MARK: Dependencies

    private let userService: UserServiceType
    private let conversationService: ConversationServiceType
    private let conversationSocketService: ConversationSocketServiceType
    private weak var delegate: ConversationListViewModelDelegate?

    // MARK: Private

    private let navigationTypeAction = PassthroughSubject<ConversationListNavigationType?, Never>()

    private let currentUserSubject = PassthroughSubject<User, Never>()
    private let conversationsSubject = PassthroughSubject<[Conversation], Never>()

    private var cancellables = Set<AnyCancellable>()

    init(userService: UserServiceType = UserService.default,
         conversationService: ConversationServiceType = ConversationService.default,
         conversationSocketService: ConversationSocketServiceType = ConversationSocketService.default,
         delegate: ConversationListViewModelDelegate? = nil) {
        self.userService = userService
        self.conversationService = conversationService
        self.conversationSocketService = conversationSocketService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
        configureLoadData()
        configureActions()
    }

    private func configureBindData() {
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
                self?.conversations = $0
                self?.viewState = .content
            })
            .store(in: &cancellables)
    }

    private func configureLoadData() {
        isAppearSubject
            .filter { $0 }
            .first()
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<[Conversation], Error>().eraseToAnyPublisher()
                }
                return self.conversationService.getConversations()
            }
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(conversations):
                    logger.info("Get conversations successful")
                    self.conversationsSubject.send(conversations)
                case let .failure(error):
                    logger.error("Get conversations failed - \(error.localizedDescription)")
                    self.error = error
                    self.viewState = .error
                }
            })
            .store(in: &cancellables)

        userService
            .currentUserPublisher
            .sink(receiveValue: { [weak self] in self?.currentUserSubject.send($0) })
            .store(in: &cancellables)

        conversationSocketService.register()
    }

    private func configureActions() {
        openChatTrigger
            .withLatestFrom(conversationsSubject) { ($0, $1) }
            .compactMap { conversationItemModel, conversations in
                conversations.first(where: { $0.id == conversationItemModel.id })
            }
            .sink(receiveValue: { [weak self] in self?.navigationType = .chat($0) })
            .store(in: &cancellables)

        navigationTypeAction
            .flatMapLatestToResult { [weak self] navigationType in
                guard let self else {
                    return Empty<ConversationListNavigationType?, Never>().eraseToAnyPublisher()
                }
                return self.isPresentingSubject
                    .filter { !$0 }
                    .first()
                    .map { _ in navigationType }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] result in
                switch result {
                case let .success(navigationType):
                    self?.navigationType = navigationType
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: CreateConversationContactListViewModelDelegate

extension ConversationListViewModel: CreateConversationContactListViewModelDelegate {
    func didCreateConversation(_ conversation: Conversation) {
        navigationType = .chat(conversation)
    }
}

// MARK: CreateConversationViewModelDelegate

extension ConversationListViewModel: CreateConversationViewModelDelegate {
    func didSelectType(type: ConversationType) {
        fullScreenCoverType = nil
        navigationTypeAction.send(.contactList(type))
    }
}
