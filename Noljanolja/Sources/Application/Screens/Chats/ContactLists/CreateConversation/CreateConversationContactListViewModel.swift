//
//  CreateConversationContactListViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import Combine
import Foundation
import UIKit

// MARK: - CreateConversationContactListViewModelDelegate

protocol CreateConversationContactListViewModelDelegate: AnyObject {
    func didCreateConversation(_ conversation: Conversation)
}

// MARK: - CreateConversationContactListViewModel

final class CreateConversationContactListViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    
    // MARK: Action

    let createConversationAction = PassthroughSubject<(ConversationType, [User]), Never>()

    // MARK: Dependencies

    private let conversationService: ConversationServiceType
    private weak var delegate: CreateConversationContactListViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(conversationService: ConversationServiceType = ConversationService.default,
         delegate: CreateConversationContactListViewModelDelegate? = nil) {
        self.conversationService = conversationService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureCreateConversation()
    }

    private func configureCreateConversation() {
        createConversationAction
            .filter { !$0.1.isEmpty }
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] createConversationType, users -> AnyPublisher<Conversation, Error> in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationService
                    .createConversation(type: createConversationType, participants: users)
            }
            .sink(receiveValue: { [weak self] result in
                self?.isProgressHUDShowing = false
                switch result {
                case let .success(conversation):
                    logger.info("Create conversation successful - conversation id: \(conversation.id)")
                    self?.delegate?.didCreateConversation(conversation)
                case let .failure(error):
                    logger.error("Create conversation failed: \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)
    }
}
