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

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: ChatAttachmentsViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: ChatAttachmentsViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
