//
//  ConversationTitleViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - ConversationTitleViewModelDelegate

protocol ConversationTitleViewModelDelegate: AnyObject {
    func didUpdateTitle()
}

// MARK: - ConversationTitleViewModel

final class ConversationTitleViewModel: ViewModel {
    // MARK: State

    @Published var title = ""
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Action

    let actionSubject = PassthroughSubject<Void, Never>()
    let closeSubject = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let conversation: Conversation
    private let conversationService: ConversationServiceType
    private weak var delegate: ConversationTitleViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(conversation: Conversation,
         conversationService: ConversationServiceType = ConversationService.default,
         delegate: ConversationTitleViewModelDelegate? = nil) {
        self.conversation = conversation
        self.conversationService = conversationService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        title = conversation.title ?? ""

        actionSubject
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationService
                    .updateConversation(
                        conversationID: self.conversation.id,
                        title: self.title
                    )
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    logger.info("Update conversation title successful")
                    self.closeSubject.send(())
                case let .failure(error):
                    logger.error("Update conversation title failed: \(error.localizedDescription)")
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
