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
    func createConversationContactListViewModel(didCreateConversation conversation: Conversation)
}

// MARK: - CreateConversationContactListViewModel

final class CreateConversationContactListViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    
    // MARK: Action

    let action = PassthroughSubject<[User], Never>()
    let closeAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let createConversationType: ConversationType
    private let conversationUseCases: ConversationUseCases
    private weak var delegate: CreateConversationContactListViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(createConversationType: ConversationType,
         conversationUseCases: ConversationUseCases = ConversationUseCasesImpl.default,
         delegate: CreateConversationContactListViewModelDelegate? = nil) {
        self.createConversationType = createConversationType
        self.conversationUseCases = conversationUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureCreateConversation()
    }

    private func configureCreateConversation() {
        action
            .filter { !$0.isEmpty }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] users -> AnyPublisher<Conversation, Error> in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationUseCases
                    .createConversation(type: self.createConversationType, participants: users)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                self?.isProgressHUDShowing = false
                switch result {
                case let .success(conversation):
                    self?.delegate?.createConversationContactListViewModel(didCreateConversation: conversation)
                case .failure:
                    break
                }
            })
            .store(in: &cancellables)
    }
}
