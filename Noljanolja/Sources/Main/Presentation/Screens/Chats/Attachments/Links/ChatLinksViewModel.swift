//
//  ChatLinksViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/08/2023.
//
//

import Combine
import Foundation

// MARK: - ChatLinksViewModelDelegate

protocol ChatLinksViewModelDelegate: AnyObject {}

// MARK: - ChatLinksViewModel

final class ChatLinksViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: ChatLinksViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: ChatLinksViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
