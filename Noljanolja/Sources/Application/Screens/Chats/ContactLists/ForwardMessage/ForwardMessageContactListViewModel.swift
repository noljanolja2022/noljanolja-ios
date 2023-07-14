//
//  ForwardMessageContactListViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/07/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - ForwardMessageContactListViewModelDelegate

protocol ForwardMessageContactListViewModelDelegate: AnyObject {}

// MARK: - ForwardMessageContactListViewModel

final class ForwardMessageContactListViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Action

    let action = PassthroughSubject<[User], Never>()
    let closeAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let message: Message

    private weak var delegate: ForwardMessageContactListViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(message: Message,
         delegate: ForwardMessageContactListViewModelDelegate? = nil) {
        self.message = message
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureUpdateConversation()
    }

    private func configureUpdateConversation() {
//        actionSubject
//            .filter { !$0.isEmpty }
//            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
//            .flatMapLatestToResult { [weak self] users -> AnyPublisher<Conversation, Error> in
//                guard let self else {
//                    return Empty<Conversation, Error>().eraseToAnyPublisher()
//                }
//                return self.conversationService
//                    .addParticipant(conversationID: self.conversation.id, participants: users)
//            }
//            .sink(receiveValue: { [weak self] result in
//                guard let self else { return }
//                self.isProgressHUDShowing = false
//                switch result {
//                case .success:
//                    self.closeSubject.send()
//                case .failure:
//                    self.alertState = AlertState(
//                        title: TextState(L10n.commonErrorTitle),
//                        message: TextState(L10n.commonErrorDescription),
//                        dismissButton: .cancel(TextState("OK"))
//                    )
//                }
//            })
//            .store(in: &cancellables)
    }
}
