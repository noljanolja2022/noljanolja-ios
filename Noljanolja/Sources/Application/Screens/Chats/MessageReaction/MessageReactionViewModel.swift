//
//  MessageReactionViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation
import UIKit

// MARK: - MessageReactionViewModelDelegate

protocol MessageReactionViewModelDelegate: AnyObject {}

// MARK: - MessageReactionViewModel

final class MessageReactionViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var reactionIcons = [ReactIcon]()

    // MARK: Action

    let closeAction = PassthroughSubject<Void, Never>()
    let reactionAction = PassthroughSubject<ReactIcon, Never>()
    let action = PassthroughSubject<MessageReactionAction, Never>()

    // MARK: Dependencies

    let messageReactionInput: MessageReactionInput
    private let reactionIconsUseCases: ReactionIconsUseCasesProtocol
    private let messageReactionUseCases: MessageReactionUseCases
    private weak var delegate: MessageReactionViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(messageReactionInput: MessageReactionInput,
         reactionIconsUseCases: ReactionIconsUseCasesProtocol = ReactionIconsUseCases.default,
         messageReactionUseCases: MessageReactionUseCases = MessageReactionUseCasesImpl.shared,
         delegate: MessageReactionViewModelDelegate? = nil) {
        self.messageReactionInput = messageReactionInput
        self.reactionIconsUseCases = reactionIconsUseCases
        self.messageReactionUseCases = messageReactionUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
        configureActions()
    }

    private func configureLoadData() {
        isAppearSubject
            .first(where: { $0 })
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isProgressHUDShowing = true
            })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<[ReactIcon], Error> in
                guard let self else {
                    return Empty<[ReactIcon], Error>().eraseToAnyPublisher()
                }
                return self.reactionIconsUseCases.getReactionIcons()
            }
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.reactionIcons = model
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func configureActions() {
        reactionAction
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] reactionIcon -> AnyPublisher<Void, Error> in
                guard let self else {
                    return Fail<Void, Error>(error: CommonError.unknown).eraseToAnyPublisher()
                }
                return self.messageReactionUseCases.reactMessage(
                    message: self.messageReactionInput.message,
                    reactionId: reactionIcon.id
                )
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
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
            }
            .store(in: &cancellables)

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }
                switch action {
                case .reply, .forward, .delete:
                    break
                case .copy:
                    switch self.messageReactionInput.message.type {
                    case .plaintext:
                        guard let message = self.messageReactionInput.message.message else { return }
                        UIPasteboard.general.string = message
                    case .photo, .sticker, .eventUpdated, .eventJoined, .eventLeft, .unknown:
                        break
                    }
                }
            }
            .store(in: &cancellables)
    }
}
