//
//  TermOfServiceDetailViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/04/2023.
//
//

import Combine
import Foundation

// MARK: - TermOfServiceDetailViewModelDelegate

protocol TermOfServiceDetailViewModelDelegate: AnyObject {}

// MARK: - TermOfServiceDetailViewModel

final class TermOfServiceDetailViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: TermOfServiceDetailViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: TermOfServiceDetailViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
