//
//  ConversationListViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import Combine
import Foundation

// MARK: - ConversationListViewModelDelegate

protocol ConversationListViewModelDelegate: AnyObject {}

// MARK: - ConversationListViewModelType

protocol ConversationListViewModelType:
    ViewModelType where State == ConversationListViewModel.State, Action == ConversationListViewModel.Action {}

extension ConversationListViewModel {
    struct State {
        var conversationModels = [ConversationModel]()
    }

    enum Action {
        case loadData
    }
}

// MARK: - ConversationListViewModel

final class ConversationListViewModel: ConversationListViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private weak var delegate: ConversationListViewModelDelegate?

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         delegate: ConversationListViewModelDelegate? = nil) {
        self.state = state
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .loadData:
            state.conversationModels = false
                ? [
                    ConversationModel(
                        avatar: "https://upload.wikimedia.org/wikipedia/en/8/86/Avatar_Aang.png",
                        name: "Trinh",
                        lastMessage: "Hi, everyone"
                    )
                ]
                : []
        }
    }

    private func configure() {}
}
