//
//  ChatViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/03/2023.
//
//

import Combine
import Foundation

// MARK: - ChatViewModelDelegate

protocol ChatViewModelDelegate: AnyObject {}

// MARK: - ChatViewModelType

protocol ChatViewModelType:
    ViewModelType where State == ChatViewModel.State, Action == ChatViewModel.Action {}

extension ChatViewModel {
    struct State {
        var text = ""
    }

    enum Action {}
}

// MARK: - ChatViewModel

final class ChatViewModel: ChatViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private weak var delegate: ChatViewModelDelegate?

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         delegate: ChatViewModelDelegate? = nil) {
        self.state = state
        self.delegate = delegate

        configure()
    }

    func send(_: Action) {}

    private func configure() {}
}
