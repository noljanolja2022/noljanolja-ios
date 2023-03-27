//
//  ChatMediaInputViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/03/2023.
//
//

import Combine
import Foundation

// MARK: - ChatMediaInputViewModelDelegate

protocol ChatMediaInputViewModelDelegate: AnyObject {}

// MARK: - ChatMediaInputViewModelType

protocol ChatMediaInputViewModelType: ObservableObject {}

// MARK: - ChatMediaInputViewModel

final class ChatMediaInputViewModel: ChatMediaInputViewModelType {
    // MARK: State

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: ChatMediaInputViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: ChatMediaInputViewModelDelegate? = nil) {
        self.delegate = delegate

        configure()
    }

    private func configure() {}
}
