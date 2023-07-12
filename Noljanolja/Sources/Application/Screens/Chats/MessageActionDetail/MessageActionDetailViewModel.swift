//
//  MessageActionDetailViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation
import UIKit

// MARK: - MessageActionDetailViewModelDelegate

protocol MessageActionDetailViewModelDelegate: AnyObject {
    func messageActionDetailDelete(_ message: Message)
}

// MARK: - MessageActionDetailViewModel

final class MessageActionDetailViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var reactionIcons = [ReactIcon]()
    @Published var messageActionTypes = [MessageActionType]()

    // MARK: Action

    let closeAction = PassthroughSubject<Void, Never>()
    let reactionAction = PassthroughSubject<ReactIcon, Never>()
    let action = PassthroughSubject<MessageActionType, Never>()

    // MARK: Dependencies

    let input: MessageActionDetailInput
    private let userService: UserServiceType
    private let reactionIconsUseCases: ReactionIconsUseCasesProtocol
    private let messageReactionUseCases: MessageReactionUseCases
    private weak var delegate: MessageActionDetailViewModelDelegate?

    // MARK: Private

    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()

    init(input: MessageActionDetailInput,
         userService: UserServiceType = UserService.default,
         reactionIconsUseCases: ReactionIconsUseCasesProtocol = ReactionIconsUseCases.default,
         messageReactionUseCases: MessageReactionUseCases = MessageReactionUseCasesImpl.shared,
         delegate: MessageActionDetailViewModelDelegate? = nil) {
        self.input = input
        self.userService = userService
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
        userService
            .getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in self?.currentUserSubject.send($0) })
            .store(in: &cancellables)

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

        currentUserSubject
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentUser in
                guard let self else { return }
                if self.input.message.sender.id == currentUser.id {
                    self.messageActionTypes = MessageActionType.allCases
                } else {
                    self.messageActionTypes = [.reply, .forward, .copy]
                }
            }
            .store(in: &cancellables)
    }

    private func configureActions() {
        reactionAction
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
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
                self.isProgressHUDShowing = false
                self.closeAction.send()
            }
            .store(in: &cancellables)

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }
                switch action {
                case .reply, .forward:
                    break
                case .delete:
                    closeAction.send()
                    delegate?.messageActionDetailDelete(input.message)
                case .copy:
                    switch self.input.message.type {
                    case .plaintext:
                        guard let message = self.input.message.message else { return }
                        UIPasteboard.general.string = message
                        closeAction.send()
                    case .photo, .sticker, .eventUpdated, .eventJoined, .eventLeft, .unknown:
                        break
                    }
                }
            }
            .store(in: &cancellables)
    }
}
