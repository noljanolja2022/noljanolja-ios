//
//  SourceLicenseViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/05/2023.
//
//

import Combine
import Foundation

// MARK: - SourceLicenseViewModelDelegate

protocol SourceLicenseViewModelDelegate: AnyObject {}

// MARK: - SourceLicenseViewModel

final class SourceLicenseViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    // MARK: Navigations

    @Published var navigationType: SourceLicenseNavigationType?

    // MARK: Dependencies

    private weak var delegate: SourceLicenseViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: SourceLicenseViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
