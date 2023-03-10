//
//  ChatInputViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//
//

import Combine
import Foundation

// MARK: - ChatInputViewModelDelegate

protocol ChatInputViewModelDelegate: AnyObject {}

// MARK: - ChatInputViewModelType

protocol ChatInputViewModelType:
    ViewModelType where State == ChatInputViewModel.State, Action == ChatInputViewModel.Action {}

extension ChatInputViewModel {
    struct State {
        let conversation: Conversation

        var text = ""
    }

    enum Action {
        case sendPlaintextMessage
    }
}

// MARK: - ChatInputViewModel

final class ChatInputViewModel: ChatInputViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private let conversationDetailService: ConversationDetailServiceType
    private weak var delegate: ChatInputViewModelDelegate?

    // MARK: Action

    private let sendPlaintextMessage = PassthroughSubject<String, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State,
         conversationDetailService: ConversationDetailServiceType = ConversationDetailService.default,
         delegate: ChatInputViewModelDelegate? = nil) {
        self.state = state
        self.conversationDetailService = conversationDetailService
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .sendPlaintextMessage:
            sendPlaintextMessage.send(state.text)
        }
    }

    private func configure() {
        sendPlaintextMessage
            .flatMapLatestToResult { [weak self] message in
                guard let self else {
                    return Empty<Message, Error>().eraseToAnyPublisher()
                }
                return self.conversationDetailService
                    .sendMessage(
                        conversationID: self.state.conversation.id,
                        message: message,
                        type: .plaintext
                    )
            }
            .sink { result in
                print(result)
            }
            .store(in: &cancellables)
    }
}
