//
//  ChatAttachmentsViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/08/2023.
//
//

import Combine
import Foundation

// MARK: - ChatAttachmentsViewModelDelegate

protocol ChatAttachmentsViewModelDelegate: AnyObject {}

// MARK: - ChatAttachmentsViewModel

final class ChatAttachmentsViewModel: ViewModel {
    // MARK: State

    @Published var selectedAttachmentType = ConversationAttachmentType.photo
    @Published var allAttachmentTypes: [ConversationAttachmentType] = [.photo, .file, .link]

    // MARK: Action

    // MARK: Dependencies

    let conversation: Conversation
    private weak var delegate: ChatAttachmentsViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(conversation: Conversation,
         delegate: ChatAttachmentsViewModelDelegate? = nil) {
        self.conversation = conversation
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
