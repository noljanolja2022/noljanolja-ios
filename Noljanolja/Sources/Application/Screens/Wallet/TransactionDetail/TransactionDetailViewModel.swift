//
//  TransactionDetailViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/05/2023.
//
//

import Combine
import Foundation

// MARK: - TransactionDetailViewModelDelegate

protocol TransactionDetailViewModelDelegate: AnyObject {}

// MARK: - TransactionDetailViewModel

final class TransactionDetailViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: TransactionDetailViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: TransactionDetailViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
