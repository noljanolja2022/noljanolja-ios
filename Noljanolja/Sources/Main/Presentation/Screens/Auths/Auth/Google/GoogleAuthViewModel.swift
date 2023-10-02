//
//  GoogleAuthViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/10/2023.
//
//

import Combine
import Foundation

// MARK: - GoogleAuthViewModelDelegate

protocol GoogleAuthViewModelDelegate: AnyObject {}

// MARK: - GoogleAuthViewModel

final class GoogleAuthViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: GoogleAuthViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: GoogleAuthViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
