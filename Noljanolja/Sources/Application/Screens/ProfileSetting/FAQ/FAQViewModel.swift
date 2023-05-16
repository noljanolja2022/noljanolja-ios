//
//  FAQViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/05/2023.
//
//

import Combine
import Foundation

// MARK: - FAQViewModelDelegate

protocol FAQViewModelDelegate: AnyObject {}

// MARK: - FAQViewModel

final class FAQViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: FAQViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: FAQViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
