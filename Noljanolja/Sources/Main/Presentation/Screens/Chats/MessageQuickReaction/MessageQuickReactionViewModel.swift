//
//  MessageQuickReactionViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/07/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation
import UIKit

// MARK: - MessageQuickReactionViewModelDelegate

protocol MessageQuickReactionViewModelDelegate: AnyObject {}

// MARK: - MessageQuickReactionViewModel

final class MessageQuickReactionViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var reactionIcons = [ReactIcon]()

    // MARK: Action

    let closeAction = PassthroughSubject<Void, Never>()
    let reactionAction = PassthroughSubject<ReactIcon, Never>()
    let action = PassthroughSubject<MessageActionType, Never>()

    // MARK: Dependencies

    let input: MessageQuickReactionInput
    private let reactionIconsUseCases: ReactionIconsUseCasesProtocol
    private let messageReactionUseCases: MessageReactionUseCases
    private weak var delegate: MessageQuickReactionViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(input: MessageQuickReactionInput,
         reactionIconsUseCases: ReactionIconsUseCasesProtocol = ReactionIconsUseCases.default,
         messageReactionUseCases: MessageReactionUseCases = MessageReactionUseCasesImpl.shared,
         delegate: MessageQuickReactionViewModelDelegate? = nil) {
        self.input = input
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
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<[ReactIcon], Error> in
                guard let self else {
                    return Empty<[ReactIcon], Error>().eraseToAnyPublisher()
                }
                return self.reactionIconsUseCases.getReactionIcons()
            }
            .receive(on: DispatchQueue.main)
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
            .flatMapToResult { [weak self] reactionIcon -> AnyPublisher<Void, Error> in
                guard let self else {
                    return Fail<Void, Error>(error: CommonError.unknown).eraseToAnyPublisher()
                }
                return self.messageReactionUseCases.reactMessage(
                    message: self.input.message,
                    reactionId: reactionIcon.id
                )
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.closeAction.send()
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
                    switch self.input.message.type {
                    case .plaintext:
                        guard let message = self.input.message.message else { return }
                        UIPasteboard.general.string = message
                    case .photo, .sticker, .eventUpdated, .eventJoined, .eventLeft, .unknown:
                        break
                    }
                }
            }
            .store(in: &cancellables)
    }
}
