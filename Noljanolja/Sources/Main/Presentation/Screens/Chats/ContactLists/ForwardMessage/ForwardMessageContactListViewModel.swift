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

    private let messageUseCases: MessageUseCases
    private weak var delegate: ForwardMessageContactListViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(message: Message,
         messageUseCases: MessageUseCases = MessageUseCasesImpl.default,
         delegate: ForwardMessageContactListViewModelDelegate? = nil) {
        self.message = message
        self.messageUseCases = messageUseCases
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
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] users -> AnyPublisher<[Message], Error> in
                guard let self else {
                    return Empty<[Message], Error>().eraseToAnyPublisher()
                }
                return self.messageUseCases
                    .forwardMessage(message: self.message, users: users)
            }
            .receive(on: DispatchQueue.main)
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
