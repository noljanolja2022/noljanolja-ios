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

    private let messageService: MessageServiceType
    private weak var delegate: ForwardMessageContactListViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(message: Message,
         messageService: MessageServiceType = MessageService.default,
         delegate: ForwardMessageContactListViewModelDelegate? = nil) {
        self.message = message
        self.messageService = messageService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureActions()
    }

    private func configureActions() {
        action
            .filter { !$0.isEmpty }
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] users -> AnyPublisher<[Message], Error> in
                guard let self else {
                    return Empty<[Message], Error>().eraseToAnyPublisher()
                }
                return self.messageService
                    .forwardMessage(message: self.message, users: users)
            }
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    self.closeAction.send()
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)
    }
}
