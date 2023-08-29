//
//  ChatFilesViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/08/2023.
//
//

import Combine
import Foundation

// MARK: - ChatFilesViewModelDelegate

protocol ChatFilesViewModelDelegate: AnyObject {}

// MARK: - ChatFilesViewModel

final class ChatFilesViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: ChatFilesViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: ChatFilesViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
