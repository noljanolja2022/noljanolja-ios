//
//  TermDetailViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/02/2023.
//
//

import Combine

// MARK: - TermDetailViewModelDelegate

protocol TermDetailViewModelDelegate: AnyObject {}

// MARK: - TermDetailViewModelType

protocol TermDetailViewModelType: ObservableObject {
    var termItemType: TermItemType { get set }
}

// MARK: - TermDetailViewModel

final class TermDetailViewModel: TermDetailViewModelType {
    // MARK: Dependencies

    private weak var delegate: TermDetailViewModelDelegate?

    // MARK: State

    @Published var termItemType: TermItemType

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: TermDetailViewModelDelegate? = nil,
         termItemType: TermItemType) {
        self.delegate = delegate
        self.termItemType = termItemType

        configure()
    }

    private func configure() {}
}
