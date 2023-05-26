//
//  AboutUsViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/05/2023.
//
//

import Combine
import Foundation

// MARK: - AboutUsViewModelDelegate

protocol AboutUsViewModelDelegate: AnyObject {}

// MARK: - AboutUsViewModel

final class AboutUsViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: AboutUsViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: AboutUsViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
