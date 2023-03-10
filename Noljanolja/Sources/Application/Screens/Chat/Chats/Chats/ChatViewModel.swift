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

        var messages = [MessageItemModel]()
        var error: Error?
        var viewState = ViewState.content
    }

    enum Action {
        case loadData
    }
}

// MARK: - ChatViewModel

final class ChatViewModel: ChatViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private let profileService: ProfileServiceType
    private let conversationDetailService: ConversationDetailServiceType
    private weak var delegate: ChatViewModelDelegate?

    // MARK: Action

    private let loadDataTrigger = PassthroughSubject<Void, Never>()

    // MARK: Data

    private let currentUserSubject = PassthroughSubject<User, Never>()
    private let messagesSubject = PassthroughSubject<[Message], Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State,
         profileService: ProfileServiceType = ProfileService.default,
         conversationDetailService: ConversationDetailServiceType = ConversationDetailService.default,
         delegate: ChatViewModelDelegate? = nil) {
        self.state = state
        self.profileService = profileService
        self.conversationDetailService = conversationDetailService
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .loadData:
            loadDataTrigger.send()
        }
    }

    private func configure() {
        Publishers.CombineLatest(currentUserSubject, messagesSubject)
            .map { currentUser, messages in
                messages
                    .map {
                        MessageItemModel(
                            currentUser: currentUser,
                            message: $0
                        )
                    }
            }
            .sink(receiveValue: { [weak self] in
                self?.state.messages = $0
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
                    return Empty<[Message], Error>().eraseToAnyPublisher()
                }
                return self.conversationDetailService
                    .getMessages(conversationID: self.state.conversation.id)
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(messages):
                    self?.messagesSubject.send(messages)
                case let .failure(error):
                    self?.state.error = error
                    self?.state.viewState = .error
                }
            })
            .store(in: &cancellables)
    }
}
