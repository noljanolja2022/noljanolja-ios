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
        var error: Error?
        var viewState = ViewState.content
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

    private let loadDataTrigger = PassthroughSubject<Void, Never>()

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
        case .loadData: loadDataTrigger.send()
        }
    }

    private func configure() {
        loadDataTrigger
            .handleEvents(receiveOutput: { [weak self] in self?.state.viewState = .loading })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<[ConversationModel], Error>().eraseToAnyPublisher()
                }
                let value = Bool.random()
                    ? [ConversationModel(
                        avatar: "https://upload.wikimedia.org/wikipedia/en/8/86/Avatar_Aang.png",
                        name: "Trinh",
                        lastMessage: "Hi, everyone"
                    )]
                    : []
                return Just(value).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(conversationModels):
                    self?.state.conversationModels = conversationModels
                    self?.state.viewState = .content
                case let .failure(error):
                    self?.state.error = error
                    self?.state.viewState = .error
                }
            })
            .store(in: &cancellables)
    }
}
