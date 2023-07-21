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

    @Published var model: TransactionDetailModel

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: TransactionDetailViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(transaction: Transaction,
         delegate: TransactionDetailViewModelDelegate? = nil) {
        self.model = TransactionDetailModel(model: transaction)
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
