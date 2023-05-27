//
//  ConversationAdjustmentModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation
import UIKit

// MARK: - ConversationAdjustmentModelDelegate

protocol ConversationAdjustmentModelDelegate: AnyObject {
    func didUpdateTitle()
}

// MARK: - ConversationAdjustmentModel

final class ConversationAdjustmentModel: ViewModel {
    // MARK: State

    @Published var image: UIImage?
    @Published var avatar: String?
    @Published var title = ""

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Navigation

    @Published var actionSheetType: ConversationAdjustmentActionSheetType?
    @Published var fullScreenCoverType: ConversationAdjustmentFullScreenCoverType?

    // MARK: Action

    let actionSubject = PassthroughSubject<Void, Never>()
    let closeSubject = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let conversation: Conversation
    private let conversationService: ConversationServiceType
    private weak var delegate: ConversationAdjustmentModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(conversation: Conversation,
         conversationService: ConversationServiceType = ConversationService.default,
         delegate: ConversationAdjustmentModelDelegate? = nil) {
        self.conversation = conversation
        self.conversationService = conversationService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        title = conversation.title ?? ""

        actionSubject
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<Conversation, Error>().eraseToAnyPublisher()
                }
                return self.conversationService
                    .updateConversation(
                        conversationID: self.conversation.id,
                        title: self.title
                    )
            }
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    logger.info("Update conversation title successful")
                    self.closeSubject.send(())
                case let .failure(error):
                    logger.error("Update conversation title failed: \(error.localizedDescription)")
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)
    }
}
