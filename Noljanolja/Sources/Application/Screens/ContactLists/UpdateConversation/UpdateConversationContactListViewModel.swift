//
//  UpdateConversationContactListViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - UpdateConversationContactListViewModelDelegate

protocol UpdateConversationContactListViewModelDelegate: AnyObject {}

// MARK: - UpdateConversationContactListViewModel

final class UpdateConversationContactListViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Action

    let actionSubject = PassthroughSubject<[User], Never>()
    let closeSubject = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let conversation: Conversation
    
    private let conversationService: ConversationServiceType
    private weak var delegate: UpdateConversationContactListViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(conversation: Conversation,
         conversationService: ConversationServiceType = ConversationService.default,
         delegate: UpdateConversationContactListViewModelDelegate? = nil) {
        self.conversation = conversation
        self.conversationService = conversationService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureUpdateConversation()
    }

    private func configureUpdateConversation() {
        actionSubject
            .filter { !$0.isEmpty }
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] users -> AnyPublisher<Conversation, Error> in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationService
                    .addParticipant(conversationID: self.conversation.id, participants: users)
            }
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(conversation):
                    logger.info("Add participants successful")
                    self.closeSubject.send()
                case let .failure(error):
                    logger.error("Add participants failed: \(error.localizedDescription)")
                    self.alertState = AlertState(
                        title: TextState("Error"),
                        message: TextState(L10n.Common.Error.message),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)
    }
}
