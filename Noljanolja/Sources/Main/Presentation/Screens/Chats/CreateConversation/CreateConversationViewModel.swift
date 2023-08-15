//
//  CreateConversationViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/04/2023.
//
//

import Combine
import Foundation

// MARK: - CreateConversationViewModelDelegate

protocol CreateConversationViewModelDelegate: AnyObject {
    func createConversationViewModel(type: ConversationType)
}

// MARK: - CreateConversationViewModel

final class CreateConversationViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    let conversationTypeAction = PassthroughSubject<ConversationType, Never>()

    // MARK: Dependencies

    private weak var delegate: CreateConversationViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: CreateConversationViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        conversationTypeAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.delegate?.createConversationViewModel(type: $0)
            }
            .store(in: &cancellables)
    }
}
