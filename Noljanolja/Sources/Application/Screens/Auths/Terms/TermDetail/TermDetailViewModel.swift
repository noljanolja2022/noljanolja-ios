//
//  TermDetailViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/04/2023.
//
//

import Combine
import Foundation

// MARK: - TermDetailViewModelDelegate

protocol TermDetailViewModelDelegate: AnyObject {}

// MARK: - TermDetailViewModel

final class TermDetailViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: TermDetailViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: TermDetailViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
